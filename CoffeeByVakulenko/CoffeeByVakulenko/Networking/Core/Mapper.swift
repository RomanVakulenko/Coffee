//
//  Mapper.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 20.02.2024.
//

import Foundation

enum MapperError: Error, CustomStringConvertible {
    case failParsed(reason: String)

    var description: String {
        switch self {
        case .failParsed(let reason):
            return reason
        }
    }
}

typealias MapperCompletion<T: Decodable> = (Result<T, MapperError>) -> Void

protocol MapperProtocol {
    func encode<T: Encodable>(from someArrStruct: [T]) throws -> Data
    func decode<T: Decodable> (from data: Data, toStruct: T.Type, completion: @escaping MapperCompletion<T>)
}


final class DataMapper {

    private lazy var encoder: JSONEncoder = {
        return JSONEncoder()
    }()

    private lazy var decoder: JSONDecoder = {
        return JSONDecoder()
    }()

    private let concurrentQueque = DispatchQueue(label: "concurrentForParsing", qos: .userInitiated, attributes: .concurrent)
}


// MARK: - Extensions
extension DataMapper: MapperProtocol {
    func encode<T: Encodable>(from someStruct: [T]) throws -> Data {
        do {
            let modelEncodedToData = try self.encoder.encode(someStruct)
            return modelEncodedToData
        } catch {
            throw error
        }
    }

    func decode<T>(from data: Data, toStruct: T.Type, completion: @escaping MapperCompletion<T>) where T : Decodable {
        concurrentQueque.async {
            do {
                let decodedStruct = try self.decoder.decode(toStruct, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedStruct))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(.failParsed(reason: "ошибка декодирования")))
                }
            }
        }
    }

}
