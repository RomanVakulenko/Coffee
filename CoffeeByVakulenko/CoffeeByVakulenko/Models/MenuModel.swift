//
//  MenuModel.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 06.02.2024.
//

import Foundation

// MARK: - Model
struct MenuModel: Decodable {
    var id: Int
    var name: String
    var imageURL: String
    var price: Int
}

