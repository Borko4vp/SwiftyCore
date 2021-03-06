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

protocol NetworkSession {
    func get(from url: URL, headers: [String: String], completion: @escaping (Data?, NetworkSessionError?) -> Void)
    func post(to url: URL, headers: [String: String], with parameters: Data?, completion: @escaping (Data?, NetworkSessionError?) -> Void)
    func patch(to url: URL, headers: [String: String], with parameters: Data?, completion: @escaping (Data?, NetworkSessionError?) -> Void)
    func put(to url: URL, headers: [String: String], with parameters: Data?, completion: @escaping (Data?, NetworkSessionError?) -> Void)
    func delete(from url: URL, headers: [String: String], with parameters: Data?, completion: @escaping (Data?, NetworkSessionError?) -> Void)
    
    func download(from remoteUrl: URL, to localUrl: URL, completion: @escaping (Bool) -> Void)
}
