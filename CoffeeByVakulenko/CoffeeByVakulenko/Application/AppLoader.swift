//
//  AppLoader.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 07.02.2024.
//

import UIKit

struct AppLoader {
//    private let window: UIWindow //потому что передаем window из сцены
    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryProtocol

    init(
//        window: UIWindow = UIWindow(frame: UIScreen.main.bounds),
         navigationController: UINavigationController = UINavigationController(),
         moduleFactory: ModuleFactoryProtocol = ModuleFactory()) {
//        self.window = window
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }

    func build(with sceneWindow: UIWindow) {
        let module = moduleFactory.makeRegistrationOrLogin(using: navigationController)
        let viewController = module.assemble()
        setRootViewController(viewController, for: sceneWindow)
    }

    private func setRootViewController(_ viewController: UIViewController?, for sceneWindow: UIWindow) {
        sceneWindow.rootViewController = navigationController

        if let viewController = viewController {
            navigationController.pushViewController(viewController, animated: true)
        }

        sceneWindow.makeKeyAndVisible()
    }

}
