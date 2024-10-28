//
//  File.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 09.02.2024.
//

import Foundation
import Alamofire


// MARK: - POST for registration and login
extension NetworkService {

    func postWith(_ parameters: [String: Any], completion: @escaping (Result<LoginResponseModel, Error>) -> Void) {

        let url = urlRequest.makeURL()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["accept": "application/json", "Content-Type": "application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResponseModel.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    completion(.success(loginResponse))
                    print("loginResponse.token - \(loginResponse.token)")
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

}


// MARK: - GET locations
extension NetworkService {

    func getLocationsOfCafes(completion: @escaping (Result<[LocationResponseModel], Error>) -> Void) {

        if let token = appKeychain.token {
            let headers: HTTPHeaders = [ "accept": "application/json", "Authorization": "Bearer \(token)"]
            let url = urlRequest.makeURL()
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
            //добывает респонс модель
                .responseDecodable(of: [LocationResponseModel].self) { response in
                    switch response.result {
                    case .success(let locations):
                        completion(.success(locations))

                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    }

    func getMenuForChoosenCafe(completion: @escaping (Result<[MenuModel], Error>) -> Void) {

        if let token = appKeychain.token {
            let headers: HTTPHeaders = [ "accept": "application/json", "Authorization": "Bearer \(token)"]
            let url = urlRequest.makeURL()

            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [MenuModel].self) { response in
                    switch response.result {
                    case .success(let menu):
                        completion(.success(menu))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    }
}
//хотел применить фабрику - да c Alamofire не совсем получилось...с URLSession фабрику работала
//    func postWith<Resource: Encodable>(resource: Resource, completion: @escaping (Result<LoginResponseModel, Error>) -> Void) {
//
//        var request = urlRequest.makeURL()
//        request.httpMethod = "POST"
//        request.httpBody = try? JSONEncoder().encode(resource)
//
//        session.loadData(from: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data, data.isEmpty == false else {
//                completion(.failure(ServiceError.expectedDataInResponse))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
//                completion(.failure(ServiceError.unexpectedResponse))
//                return
//            }
//            ///здесь мы декодировали пришедшую data от сервера Response в LoginResponseModel
//            guard let loginResponseModel = try? JSONDecoder().decode(LoginResponseModel.self, from: data) else {
//                completion(.failure(ServiceError.unexpectedResponse))
//                return
//            }
//            print("Token from postWith \(loginResponseModel.token)")
//
//            completion(.success(loginResponseModel))
//        }
//    }
//}
