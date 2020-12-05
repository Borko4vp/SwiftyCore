//
//  Networking.swift
//  CommonCore
//
//  Created by Borko Tomic on 01/06/2020.
//

import Foundation

extension SwiftyCore {
    public struct Networking {
        /// Responsible for handling all networking calls
        /// - Warning:   Must create before using any public API
        public class Manager<ServerErrorDTO: ServerErrorMessageable> {
            public init(type: NetworkSessionType) {
                switch type {
                case .urlSession:
                    session = URLSession.shared
                case .alamofire:
                    session = nil
                }
            }
            
            internal var session: NetworkSession?
            
            public enum NetworkResult<ResponseType: Codable> {
                case success(ResponseType?)
                case failure(CoreNetworkingError<ServerErrorDTO>?)
            }
            
            public func getResponse<Response: Codable, Request: NetworkRequest>(for request: Request, completion: @escaping (NetworkResult<Response>) -> Void) {
                guard let urlPath = request.path else { fatalError() }
                switch request.method {
                case .get:
                    get(from: urlPath, headers: request.headers ?? [:], completion: completion)
                case .post:
                    post(to: urlPath, headers: request.headers ?? [:], with: request.parameters, completion: completion)
                case .patch:
                    patch(to: urlPath, headers: request.headers ?? [:], with: request.parameters, completion: completion)
                }
            }
            /// Calls the live internet to retrieve Data from specific localtion
            /// - Parameters:
            ///   - url: the location you wish to fetch data from
            ///   - completion: completion to execute after API response is received
            private func get<Response: Codable>(from url: URL,
                                                headers: [String: String],
                                                completion: @escaping (NetworkResult<Response>) -> Void) {
                session?.get(from: url, headers: headers) { (responseData, error) in
                    self.handle(responseData: responseData, networkSeesionError: error, completion: completion)
                }
            }
            
            /// Calls the live internet to send Data to specific localtion
            /// - Warning: Make sure the url in question can accept POST route
            /// - Parameters:
            ///   - url: the localtion you wish to send data to
            ///   - body: the object you wish to send over the network
            ///   - completion: completion to execute after API response is received
            private func post<Response: Codable>(to url: URL,
                                                 headers: [String: String],
                                                 with body: [String: Any]?,
                                                 completion: @escaping (NetworkResult<Response>) -> Void) {
                guard let dataParams = try? JSONSerialization.data(withJSONObject: body ?? [:]) else {
                    completion(.failure(.localError(.encodeDataFailed)))
                    return
                }
                session?.post(to: url, headers: headers, with: dataParams) { responseData, error in
                    self.handle(responseData: responseData, networkSeesionError: error, completion: completion)
                }
            }
            
            /// Calls the live internet to send Data to specific localtion
            /// - Warning: Make sure the url in question can accept PATCH route
            /// - Parameters:
            ///   - url: the localtion you wish to send data to
            ///   - body: the object you wish to send over the network
            ///   - completion: completion to execute after API response is received
            private func patch<ResponseType: Codable>(to url: URL,
                                                      headers: [String: String],
                                                      with body: [String: Any]?,
                                                      completion: @escaping (NetworkResult<ResponseType>) -> Void) {
                guard let dataParams = try? JSONSerialization.data(withJSONObject: body ?? [:]) else {
                    completion(.failure(.localError(.encodeDataFailed)))
                    return
                }
                session?.patch(to: url, headers: headers, with: dataParams) { responseData, error in
                    self.handle(responseData: responseData, networkSeesionError: error, completion: completion)
                }
            }
            
        }
    }
}

extension SwiftyCore.Networking.Manager {
    private func handle<ResponseType: Codable>(responseData: Data?,
                                               networkSeesionError: NetworkSessionError?,
                                               completion: @escaping (NetworkResult<ResponseType>) -> Void){
        if let networkSeesionError = networkSeesionError {
            completion(.failure(handle(networkSessionError: networkSeesionError, with: responseData)))
        } else {
            guard let responseData = responseData else {
                completion(.success(nil))
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(ResponseType.self, from: responseData) else {
                completion(.failure(.localError(.decodeDataFailed)))
                return
            }
            completion(.success(responseJSON))
        }
    }
    
    private func handle(networkSessionError error: NetworkSessionError, with response: Data?) -> CoreNetworkingError<ServerErrorDTO> {
        guard let response = response else { return .apiError(ServerError(httpStatus: error.httpStatusCode, message: error.message, payload: nil)) }
        if let decodedErrorResponse = try? JSONDecoder().decode(ServerErrorDTO.self, from: response) {
            return .apiError(ServerError(httpStatus: error.httpStatusCode, message: error.message, payload: decodedErrorResponse))
        } else {
            return .localError(.decodeErrorDataFailed)
        }
    }
}

extension SwiftyCore.Networking {
    public enum NetworkSessionType {
        case urlSession
        case alamofire
    }
    
    public enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
    }
    
    public enum Encoding {
        case none
    }
}
