//
//  CoffeeUserDefaults.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 09.02.2024.
//

import Foundation

final class CoffeeUserDefaults {

    private enum Keys {
        static let rememberMe = "coffee_remember"
        static let userName = "coffee_username"
        static let locations = "coffee_locations"
    }

    let storage: KeyValueStorage
    static let shared: CoffeeUserDefaults = .init()

    private init(storage: KeyValueStorage = UserDefaultsWrapper()) {
        self.storage = storage
    }

    var isUsernameStored: Bool? {
        get {
            return storage.bool(forKey: Keys.rememberMe)
        }
        set {
            if let newValue = newValue {
                storage.set(newValue, key: Keys.rememberMe)
            } else {
                storage.removeValue(forKey: Keys.rememberMe)
            }

        }
    }

    var username: String? {
        get {
            return storage.string(forKey: Keys.userName)
        }
        set {
            if let newValue = newValue {
                storage.set(newValue, key: Keys.userName)
            } else {
                storage.removeValue(forKey: Keys.userName)
            }

        }
    }

    var locations: Data? {
        get {
            return storage.data(forKey: Keys.locations)
        }
        set {
            if let newValue = newValue {
                storage.set(newValue, key: Keys.locations)
            } else {
                storage.removeValue(forKey: Keys.locations)
            }
        }
    }

}
