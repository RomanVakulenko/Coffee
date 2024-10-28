//
//  NetworkSession.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 09.02.2024.
//

import Foundation
import Alamofire

//хотел применить фабрику - да c Alamofire не совсем получилось...с URLSession фабрика работает

//protocol NetworkSession {
//    func loadData(from urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
//}
//
//extension Alamofire.Session: NetworkSession {
//    func loadData(from urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
//        let task = self.request(urlRequest).validate().response { response in
//            completionHandler(response.data, response.response, response.error)
//        }
//        task.resume()
//    }
//
//}
