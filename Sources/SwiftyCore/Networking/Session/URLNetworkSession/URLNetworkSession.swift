//
//  URLNetworkSession.swift
//  CommonCore
//
//  Created by Borko Tomic on 01/06/2020.
//

import Foundation

struct URLSessionError: NetworkSessionError {
    var httpStatusCode: Int?
    var message: String?
    
}

extension URLSession: NetworkSession {
    
    func get(from url: URL, headers: [String: String], completion: @escaping (Data?, NetworkSessionError?) -> Void) {
        let request = createRequest(url: url, headers: headers, method: "GET", parameters: nil)
        createDataTask(with: request, completion: completion)
    }
    
    func post(to url: URL, headers: [String: String], with parameters: Data?, completion: @escaping (Data?, NetworkSessionError?) -> Void) {
        let request = createRequest(url: url, headers: headers, method: "POST", parameters: parameters)
        createDataTask(with: request, completion: completion)
    }
    
    func patch(to url: URL, headers: [String: String], with parameters: Data?, completion: @escaping (Data?, NetworkSessionError?) -> Void) {
        let request = createRequest(url: url, headers: headers, method: "PATCH", parameters: parameters)
        createDataTask(with: request, completion: completion)
    }
}

extension URLSession {
    private func createRequest(url: URL, headers: [String: String], method: String, parameters: Data?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpBody = parameters
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        return request
    }
    
    @discardableResult
    private func createDataTask(with request: URLRequest, completion: @escaping (Data?, NetworkSessionError?) -> Void) -> URLSessionDataTask {
        let task = dataTask(with: request) { data, response, error in
           if let code = (response as? HTTPURLResponse)?.statusCode, code > 400 {
                let urlSessionError = URLSessionError(httpStatusCode: code, message: error?.localizedDescription ?? "")
                completion(data, urlSessionError)
            } else {
                completion(data, nil)
            }
        }
        task.resume()
        return task
    }
}
