//
//  OrderRouter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 28.02.2024.
//

import UIKit

final class OrderRouter {

    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryProtocol

    init(navigationController: UINavigationController = UINavigationController(),
         moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }

}

extension OrderRouter: OrderRouterProtocol {
    func payFor(_ order: [OrderModel]) {
        //ФИНИШ
    }
}
