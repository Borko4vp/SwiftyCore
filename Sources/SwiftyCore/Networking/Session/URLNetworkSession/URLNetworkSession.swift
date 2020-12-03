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
        let task = dataTask(with: url) { data, response, error in
            if let error = error {
                let urlSessionError = URLSessionError(httpStatusCode: (response as? HTTPURLResponse)?.statusCode, message: error.localizedDescription)
                completion(data, urlSessionError)
            } else {
                completion(data, nil)
            }
        }
        task.resume()
    }
    
    func post(to url: URL, headers: [String: String], with parameters: Data?, completion: @escaping (Data?, NetworkSessionError?) -> Void) {
        var request = URLRequest(url: url)
        request.httpBody = parameters
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        let task = dataTask(with: request) { data, response, error in
           if let error = error {
                let urlSessionError = URLSessionError(httpStatusCode: (response as? HTTPURLResponse)?.statusCode, message: error.localizedDescription)
                completion(data, urlSessionError)
            } else {
                completion(data, nil)
            }
        }
        task.resume()
    }
}
