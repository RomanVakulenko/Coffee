//
//  Endpoint.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 09.02.2024.
//

import Foundation

// MARK: - Endpoint
protocol Endpoint {
    var path: String { get set }
    var queryItems: [URLQueryItem]? { get set }
    var scheme: String? { get }
    var host: String? { get }
    var port: Int? { get }
    var url: URL? { get }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        components.port = port

        return components.url
    }
}



// MARK: - Basic implementation
struct StandardEndpoint: Endpoint { //http://147.78.66.203:3210/auth/register
    var path: String
    var queryItems: [URLQueryItem]? = nil
    var scheme: String? = "http"
    var host: String? = "147.78.66.203"
    var port: Int? = 3210

    init(path: String) {
        self.path = path
    }
}

extension StandardEndpoint: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        path = value
    }
}
