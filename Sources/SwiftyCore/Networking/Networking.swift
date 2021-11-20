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
            private var loggingEnabled: Bool = false
            public init(type: NetworkSessionType, logging: Bool) {
                loggingEnabled = logging
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
                if loggingEnabled { print("\(request.method.rawValue) \(urlPath.absoluteString)") }
                switch request.method {
                case .get:
                    get(from: urlPath, headers: request.headers ?? [:], completion: completion)
                case .post:
                    if request.headers?["Content-Type"]?.contains("multipart/form-data") ?? false {
                        post(to: urlPath, headers: request.headers ?? [:], with: request.parameters?[SwiftyCore.Networking.multipartDataKey] as? Data, completion: completion)
                    } else {
                        post(to: urlPath, headers: request.headers ?? [:], with: request.parameters, completion: completion)
                    }
                case .patch:
                    patch(to: urlPath, headers: request.headers ?? [:], with: request.parameters, completion: completion)
                case .put:
                    put(to: urlPath, headers: request.headers ?? [:], with: request.parameters, completion: completion)
                case .delete:
                    delete(from: urlPath, headers: request.headers ?? [:], with: request.parameters, completion: completion)
                    
                }
            }
            
            public func download(from remoteUrl: URL, to localUrl: URL, completion: @escaping (Bool) -> Void) {
                session?.download(from: remoteUrl, urlRequestHeaders: nil, to: localUrl, completion: completion)
            }
        }
    }
}

extension SwiftyCore.Networking.Manager {
    
    /// Calls the live internet to retrieve Data from specific localtion
    /// - Parameters:
    ///   - url: the location you wish to fetch data from
    ///   - completion: completion to execute after API response is received
    private func get<Response: Codable>(from url: URL,
                                        headers: [String: String],
                                        completion: @escaping (NetworkResult<Response>) -> Void) {
        session?.get(from: url, headers: headers) { (responseData, error) in
            self.handle(urlString: url.absoluteString, responseData: responseData, networkSeesionError: error, completion: completion)
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
//        let stringData = String(data: data, encoding: .utf8)
//        print(stringData ?? "")
        session?.post(to: url, headers: headers, with: dataParams) { responseData, error in
            self.handle(urlString: url.absoluteString, responseData: responseData, networkSeesionError: error, completion: completion)
        }
    }
    /// Calls the live internet to send Data to specific localtion
    /// - Warning: Make sure the url in question can accept POST route
    /// - Parameters:
    ///   - url: the localtion you wish to send data to
    ///   - data: the data object you wish to send over the network
    ///   - completion: completion to execute after API response is received
    private func post<Response: Codable>(to url: URL,
                                         headers: [String: String],
                                         with data: Data?,
                                         completion: @escaping (NetworkResult<Response>) -> Void) {
        guard let dataParams = data else {
            completion(.failure(.localError(.encodeDataFailed)))
            return
        }
        session?.post(to: url, headers: headers, with: dataParams) { responseData, error in
            self.handle(urlString: url.absoluteString, responseData: responseData, networkSeesionError: error, completion: completion)
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
            self.handle(urlString: url.absoluteString, responseData: responseData, networkSeesionError: error, completion: completion)
        }
    }
    
    /// Calls the live internet to send Data to specific localtion
    /// - Warning: Make sure the url in question can accept PUT route
    /// - Parameters:
    ///   - url: the localtion you wish to send data to
    ///   - body: the object you wish to send over the network
    ///   - completion: completion to execute after API response is received
    private func put<ResponseType: Codable>(to url: URL,
                                              headers: [String: String],
                                              with body: [String: Any]?,
                                              completion: @escaping (NetworkResult<ResponseType>) -> Void) {
        guard let dataParams = try? JSONSerialization.data(withJSONObject: body ?? [:]) else {
            completion(.failure(.localError(.encodeDataFailed)))
            return
        }
        session?.put(to: url, headers: headers, with: dataParams) { responseData, error in
            self.handle(urlString: url.absoluteString, responseData: responseData, networkSeesionError: error, completion: completion)
        }
    }
    
    /// Calls the live internet to send Data to specific localtion
    /// - Warning: Make sure the url in question can accept PUT route
    /// - Parameters:
    ///   - url: the localtion you wish to send data to
    ///   - body: the object you wish to send over the network
    ///   - completion: completion to execute after API response is received
    private func delete<ResponseType: Codable>(from url: URL,
                                               headers: [String: String],
                                               with body: [String: Any]?,
                                               completion: @escaping (NetworkResult<ResponseType>) -> Void) {
        guard let dataParams = try? JSONSerialization.data(withJSONObject: body ?? [:]) else {
            completion(.failure(.localError(.encodeDataFailed)))
            return
        }
        session?.delete(from: url, headers: headers, with: dataParams) { responseData, error in
            self.handle(urlString: url.absoluteString, responseData: responseData, networkSeesionError: error, completion: completion)
        }
    }
    
    private func handle<ResponseType: Codable>(urlString: String,
                                               responseData: Data?,
                                               networkSeesionError: NetworkSessionError?,
                                               completion: @escaping (NetworkResult<ResponseType>) -> Void){
        if let networkSeesionError = networkSeesionError {
            if loggingEnabled {
                if let data = responseData, let stringData = String(data: data, encoding: .utf8) {
                    print(stringData)
                }
            }
            completion(.failure(handle(networkSessionError: networkSeesionError, with: responseData)))
        } else {
            guard let responseData = responseData else {
                completion(.success(nil))
                return
            }
            if loggingEnabled {
                let stringData = String(data: responseData, encoding: .utf8)
                print("RESPONSE from: " + urlString + "\n" + (stringData ?? ""))
            }
            guard let responseJSON = ResponseType(with: responseData) else {
                completion(.failure(.localError(.decodeDataFailed)))
                return
            }
            completion(.success(responseJSON))
        }
    }
    
    private func handle(networkSessionError error: NetworkSessionError, with response: Data?) -> CoreNetworkingError<ServerErrorDTO> {
        guard let response = response else { return .apiError(ServerError(httpStatus: error.httpStatusCode, message: error.message, payload: nil)) }
        if let decodedErrorResponse = ServerErrorDTO(with: response) {
            return .apiError(ServerError(httpStatus: error.httpStatusCode, message: error.message, payload: decodedErrorResponse))
        } else {
            return .localError(.decodeErrorDataFailed)
        }
    }
}

extension SwiftyCore.Networking {
    
    public static var multipartDataKey = "multipartData"
    public static var multipartBoundary = UUID().uuidString
    public static var multipartContentType = "multipart/form-data; boundary=\(SwiftyCore.Networking.multipartBoundary)"
    
    public static func addQuery(params: Codable, to route: String) -> String {
        guard let paramsDict = params.createDictionary(), !paramsDict.isEmpty else { return route }
        var newRoute = route+"?"
        var index = 0
        for (key, value) in paramsDict {
            let valueTrimmed = "\(value)".trimmingCharacters(in: .whitespacesAndNewlines)
            //guard !valueTrimmed.isEmpty else { continue }
            newRoute.append("\(key)=\(valueTrimmed)")
            if index < paramsDict.count-1 {
                newRoute.append("&")
            }
            index+=1
        }
        newRoute = newRoute.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return newRoute
    }
    
    public enum NetworkSessionType {
        case urlSession
        case alamofire
    }
    
    public enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    public enum Encoding {
        case none
    }
    
    public static func dataArrayToFormData(paramName: String, mimeType: String = "image/jpg", dataArray: [Data], filenames: [String], boundary: String = SwiftyCore.Networking.multipartBoundary) -> Data {
        var fullData = Data()
        for (index, data) in dataArray.enumerated() {
            let currentFilename = filenames[index]
            fullData.append("--\(boundary)\r\n".data(using: .utf8)!)
            fullData.append("Content-Disposition: form-data; name=\"\(paramName)\";filename=\"\(currentFilename)\"\r\n".data(using: .utf8)!)
            fullData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            fullData.append(data)
            fullData.append("\r\n".data(using: .utf8)!)
        }
        fullData.append("--\(boundary)--".data(using: .utf8)!)
        return fullData
    }
}
