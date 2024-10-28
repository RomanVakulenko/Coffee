//
//  NetworkService.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 09.02.2024.
//

import Foundation
import Alamofire
// MARK: - ServiceError
enum ServiceError: Error {
    case unexpectedResponse
    case locationHeaderNotFound
    case resourceIDNotFound
    case unexpectedResourceIDType
    case expectedDataInResponse
    case invalidRequestData
}

// MARK: - NetworkService
protocol NetworkService {
//хотел применить фабрику - да c Alamofire не совсем получилось...с URLSession работает
//    var session: NetworkSession { get set }
    var urlRequest: URLRequestFactoryProtocol { get set }
    var appKeychain: ApplicationKeychain { get set }
}


// MARK: - Basic implementation
struct StandardNetworkService: NetworkService {
    var urlRequest: URLRequestFactoryProtocol
    var appKeychain: ApplicationKeychain

    init(
        urlRequest: URLRequestFactoryProtocol,
         appKeychain: ApplicationKeychain = CoffeeKeychain.shared) {
        self.urlRequest = urlRequest
        self.appKeychain = appKeychain
    }

    init(resourcePath: String, authenticated: Bool = false) {
        let endpoint = StandardEndpoint(path: resourcePath)
        if authenticated == false {
            self.init(urlRequest: StandardURLRequestFactory(endpoint: endpoint))
        } else {
            self.init(urlRequest: AuthURLRequestFactory(endpoint: endpoint))
        }
    }
}
