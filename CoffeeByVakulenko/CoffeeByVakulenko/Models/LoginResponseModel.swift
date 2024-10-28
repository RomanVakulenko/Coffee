//
//  LoginResponseModel.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 10.02.2024.
//

import Foundation

// MARK: - Response model
struct LoginResponseModel: Decodable {
    let token: String
    let tokenLifetime: Int
}
