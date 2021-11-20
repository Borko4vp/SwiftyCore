//
//  NetworkSession.swift
//  CommonCore
//
//  Created by Borko Tomic on 03/06/2020.
//

import Foundation

protocol NetworkSessionError: Error {
    var httpStatusCode: Int? { get }
    var message: String? { get }
}

typealias NetworkResponseHandler = (Data?, NetworkSessionError?) -> Void
typealias HTTPHeaders = [String: String]

protocol NetworkSession {
    func get(from url: URL, headers: HTTPHeaders, completion: @escaping NetworkResponseHandler)
    func post(to url: URL, headers: HTTPHeaders, with parameters: Data?, completion: @escaping NetworkResponseHandler)
    func patch(to url: URL, headers: HTTPHeaders, with parameters: Data?, completion: @escaping NetworkResponseHandler)
    func put(to url: URL, headers: HTTPHeaders, with parameters: Data?, completion: @escaping NetworkResponseHandler)
    func delete(from url: URL, headers: HTTPHeaders, with parameters: Data?, completion: @escaping NetworkResponseHandler)
    
    func download(from remoteUrl: URL, urlRequestHeaders: [String: String]?, to localUrl: URL, completion: @escaping (Bool) -> Void)
}
