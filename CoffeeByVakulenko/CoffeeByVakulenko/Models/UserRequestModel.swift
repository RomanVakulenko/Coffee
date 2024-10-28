//
//  UserRequestModel.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 06.02.2024.
//

import Foundation

// MARK: - Model
struct UserRequestModel: Encodable {
    let username: String
    var password: String
}

extension UserRequestModel {
    mutating func hashPassword() {
        self.password = Crypto.hash(message: password)!
    }
}
