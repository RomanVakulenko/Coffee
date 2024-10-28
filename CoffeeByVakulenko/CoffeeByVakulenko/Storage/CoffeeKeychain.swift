//
//  CoffeeKeychain.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 09.02.2024.
//

import Foundation

protocol ApplicationKeychain {
    var username: String? { get set }
    var password: String? { get set }
    var token: String? { get set }
}

protocol KeyValueStorage {
    func string(forKey key: String) -> String?
    func data(forKey key: String) -> Data?
    func bool(forKey key: String) -> Bool?

    func set(_ value: String, key: String)
    func set(_ value: Data, key: String)
    func set(_ value: Bool, key: String)

    func removeValue(forKey key: String)
    func removeAll()
}


final class CoffeeKeychain {

    private enum Keys {
        static let username = "coffee_username"
        static let password = "coffee_password"
        static let token = "coffee_token"
    }

    let storage: KeyValueStorage
    static let shared: CoffeeKeychain = .init()

    private init(storage: KeyValueStorage = KeychainWrapper()) {
        self.storage = storage
    }

}

// MARK: - ApplicationKeychain
extension CoffeeKeychain: ApplicationKeychain {

    var username: String? {
        get {
            return storage.string(forKey: Keys.username)
        }
        set {
            if let newValue = newValue {
                storage.set(newValue, key: Keys.username)
            } else {
                storage.removeValue(forKey: Keys.username)
            }
        }
    }

    var password: String? {
        get {
            return storage.string(forKey: Keys.password)
        }
        set {
            if let newValue = newValue {
                storage.set(newValue, key: Keys.password)
            } else {
                storage.removeValue(forKey: Keys.password)
            }
        }
    }

    var token: String? {
        get {
            return storage.string(forKey: Keys.token)
        }
        set {
            if let newValue = newValue {
                storage.set(newValue, key: Keys.token)
            } else {
                storage.removeValue(forKey: Keys.token)
            }
        }
    }

}
