//
//  LocationResponseModel.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 12.02.2024.
//

import Foundation

// MARK: - Response model
struct LocationResponseModel: Codable {
    let id: Int
    let name: String
    let point: Point
}

// MARK: - Point
struct Point: Codable {
    let latitude, longitude: String
}
