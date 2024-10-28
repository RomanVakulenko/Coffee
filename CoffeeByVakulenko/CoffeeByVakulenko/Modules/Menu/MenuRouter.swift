//
//  MenuRouter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 24.02.2024.
//

import UIKit

final class MenuRouter {

    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryProtocol

    init(navigationController: UINavigationController = UINavigationController(),
         moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }

}

extension MenuRouter: MenuRouterProtocol {
    func showTheOrder(_ order: [OrderModel]) {
        let module = moduleFactory.makeOrder(using: navigationController, order: order)

        if let viewController = module.assemble() {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
