//
//  RegistrationRouter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 06.02.2024.
//  
//

import UIKit

final class RegistrationRouter {

    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryProtocol

    init(navigationController: UINavigationController = UINavigationController(),
         moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }

}

extension RegistrationRouter: RegistrationRouterProtocol {
    func showCafesListWith(_ cafes: [CafeTableModelForUI],
                           locations: [LocationResponseModel]) {
        let module = moduleFactory.makeCafesList(
            using: navigationController,
            cafes: cafes,
            modelWithLocation: locations)

        if let viewController = module.assemble() {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
