//
//  URLRequestFactory.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 09.02.2024.
//

import Foundation

// MARK: - ServiceRequest
protocol URLRequestFactoryProtocol {
//    var defaultHeaders: [String: String] { get }
    var endpoint: Endpoint { get set }
    func makeURL() -> URL
}
//хотел применить фабрику - да c Alamofire не совсем получилось...с URLSession работает
//extension URLRequestFactoryProtocol {
//    var defaultHeaders: [String: String] {
//        return ["accept": "application/json", "Content-Type": "application/json"]
//    }
//}

// MARK: - Default URL request factory
struct StandardURLRequestFactory: URLRequestFactoryProtocol {
    var endpoint: Endpoint

    func makeURL() -> URL {
        guard let url = endpoint.url else {
            fatalError("Unable to make url request")
        }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.allHTTPHeaderFields = defaultHeaders
        return url
    }
}

// MARK: - AuthURLRequestFactory
struct AuthURLRequestFactory: URLRequestFactoryProtocol {

//хотел применить фабрику - да c Alamofire не совсем получилось...с URLSession работает URLRequest
    var endpoint: Endpoint
//    private let keychain: ApplicationKeychain

    init(endpoint: Endpoint
//         keychain: ApplicationKeychain = CoffeeKeychain.shared
    ) {
        self.endpoint = endpoint
//        self.keychain = keychain
    }

    func makeURL() -> URL {
        guard let url = endpoint.url else {
            fatalError("Unable to make url request")
        }

//        var headers = defaultHeaders
//        if let token = keychain.token {
//            headers["Authorization"] = "Bearer " + token
//        }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.allHTTPHeaderFields = headers
        return url
    }
}
