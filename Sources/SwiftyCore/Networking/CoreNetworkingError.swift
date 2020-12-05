//
//  CoreNetworkingError.swift
//  CommonCore
//
//  Created by Borko Tomic on 01/06/2020.
//

import Foundation

import Foundation

/// CoreError enum used to define errors within the application
public enum CoreNetworkingError<ServerErrroDTO: ServerErrorMessageable>: Error, Equatable {
    case localError(LocalError)
    case apiError(ServerError<ServerErrroDTO>)

    public var message: String {
        switch self {
        case .localError(let localError):
            return localError.errorMessage
        case .apiError(let serverError):
            return serverError.message
        }
    }
    
    public var payloadErrorMessage: String {
        switch self {
        case .localError(let localError):
            return localError.errorMessage
        case .apiError(let serverError):
            return serverError.payload?.errorMessage ?? ""
        }
    }
    
    public var errorCode: Int {
        switch self {
        case .localError(let localError):
            return localError.rawValue
        case .apiError(let serverError):
            return serverError.httpStatus ?? 0
        }
    }
    
    public static func ==(lhs: CoreNetworkingError, rhs: CoreNetworkingError) -> Bool {
        return lhs.errorCode == rhs.errorCode
    }
}

public enum LocalError: Int {
    case serializeResponseDataFailed = 1
//    case noDataInResponse
    case encodeDataFailed
    case decodeDataFailed
    case decodeErrorDataFailed
    case noInternetConnection
    case unknownError

    var errorMessage: String {
        switch self {
        case .serializeResponseDataFailed:
            return "serializeResponseDataFailed"
//        case .noDataInResponse:
//            return "noDataInResponse"
        case .decodeDataFailed:
            return "decodeDataFailed"
        case .decodeErrorDataFailed:
            return "decodeErrorDataFailed"
        case .noInternetConnection:
            return "Internet connection appears to be offline"
        case .unknownError:
            return "unknownError"
        case .encodeDataFailed:
            return "encodeDataFailed"
        }
    }
}

public protocol ServerErrorMessageable where Self: Codable {
    var errorMessage: String { get }
}

public struct ServerError<ServerErrroDTO: ServerErrorMessageable>: Error {
    let httpStatus: Int?
    let errorMessage: String?
    let payload: ServerErrroDTO?

    init(httpStatus: Int?, message: String?, payload: ServerErrroDTO?) {
        self.httpStatus = httpStatus
        errorMessage = message
        self.payload = payload
    }
    
    var message: String {
        var message = errorMessage ?? ""
        if message.isEmpty {
            message = payload?.errorMessage ?? ""
        }
        return message
    }
}


