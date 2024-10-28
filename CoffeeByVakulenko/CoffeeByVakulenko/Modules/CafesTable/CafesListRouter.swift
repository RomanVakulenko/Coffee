//
//  CafesListRouter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 12.02.2024.
//

import UIKit

final class CafesListRouter {

    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryProtocol

    init(navigationController: UINavigationController = UINavigationController(),
         moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }

}

extension CafesListRouter: CafesListRouterProtocol {

    func showCafesOnMapWith(_ locations: [LocationResponseModel]) {
        let module = moduleFactory.makeCafesMap(using: navigationController,
                                                modelWithCoordinates: locations)
        if let viewController = module.assemble() {
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    func showCafeMenu(_ menu: [OrderModel], locations: [LocationResponseModel]) {
        let module = moduleFactory.makeMenu(using: navigationController,
                                            modelMenu: menu,
                                            modelWithLocation: locations)
        if let viewController = module.assemble() {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
