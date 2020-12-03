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
    func get(from url: URL, completion: @escaping (Data?, NetworkSessionError?) -> Void)
    func post(to url: URL, with parameters: Data?, completion: @escaping (Data?, NetworkSessionError?) -> Void)
}
