//
//  MenuInteractor.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 24.02.2024.
//

import Foundation

final class MenuInteractor: MenuInteractable {

    weak var presenter: MenuPresenterProtocol?
    var modelWithCoordinates: [LocationResponseModel] = []
    var menuModel: [OrderModel] = []

}
