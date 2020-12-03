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
        public class Manager<ServerErrorDTO: Codable> {
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
                    
                }
            }
            /// Calls the live internet to retrieve Data from specific localtion
            /// - Parameters:
            ///   - url: the location you wish to fetch data from
            ///   - completion: completion to execute after API response is received
            private func get<ResponseType: Codable>(from url: URL, headers: [String: String], completion: @escaping (NetworkResult<ResponseType>) -> Void) {
                session?.get(from: url, headers: headers) { (responseData, error) in
                    if let error = error {
                        completion(.failure(self.handle(networkSessionError: error, with: responseData)))
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
            }
            
            /// Calls the live internet to send Data to specific localtion
            /// - Warning: Make sure the url in question can accept POST route
            /// - Parameters:
            ///   - url: the localtion you wish to send data to
            ///   - body: the object you wish to send over the network
            ///   - completion: completion to execute after API response is received
            private func post<ResponseType: Codable>(to url: URL, headers: [String: String], with body: [String: Any]?, completion: @escaping (NetworkResult<ResponseType>) -> Void) {
                guard let dataParams = try? JSONSerialization.data(withJSONObject: body ?? [:]) else {
                    completion(.failure(.localError(.encodeDataFailed)))
                    return
                }
                session?.post(to: url, headers: headers, with: dataParams) { responseData, error in
                    if let error = error {
                        completion(NetworkResult.failure(self.handle(networkSessionError: error, with: responseData)))
                    } else {
                        guard let responseData = responseData else {
                            completion(.success(nil))
                            return
                        }
                        let stringData = String(data: responseData, encoding: .utf8)
                        print(stringData ?? "")
                        guard let responseJSON = try? JSONDecoder().decode(ResponseType.self, from: responseData) else {
                            completion(.failure(.localError(.decodeDataFailed)))
                            return
                        }
                        completion(.success(responseJSON))
                    }
                }
            }
        }
    }
}

extension SwiftyCore.Networking.Manager {
    private func handle(networkSessionError error: NetworkSessionError, with response: Data?) -> CoreNetworkingError<ServerErrorDTO> {
        var errorPayload: ServerErrorDTO?
        if let response = response {
            if let decodedErrorResponse = try? JSONDecoder().decode(ServerErrorDTO.self, from: response) {
                errorPayload = decodedErrorResponse
            } else {
                return .localError(.decodeErrorDataFailed)
            }
        }
        let serverError = ServerError(httpStatus: error.httpStatusCode, message: error.message, payload: errorPayload)
        return .apiError(serverError)
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
    }
    
    public enum Encoding {
        case none
    }
}
