//
//  RSSError.swift
//  NewsReader
//
//  Created by Sergey Bulyno on 12/2/24.
//

import Foundation

enum RSSError: Error, Equatable {
    case invalidRequest
    case invalidResponse
    case invalidResponseCode(Int)
    case invalidRSS(String)
    case unknownError(Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            return "Could not create proper request"
        case .invalidResponse:
            return "Could not fetch response"
        case let .invalidResponseCode(errorCode):
            return "Could not fetch response errorCode: \(errorCode)"
        case let .invalidRSS(error):
            return "Could not parse: \(error)"
        case let .unknownError(errorCode):
            return "Could not handle errorCode: \(errorCode)"
        }
    }
}
