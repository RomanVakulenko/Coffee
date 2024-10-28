//
//  AppModule.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 07.02.2024.
//

import UIKit

protocol AppModule {
    func assemble() -> UIViewController?
}

protocol ModuleFactoryProtocol {
    func makeRegistrationOrLogin(using navigationController: UINavigationController) -> RegistrationModule

    func makeCafesList(using navigationController: UINavigationController,
                       cafes: [CafeTableModelForUI],
                       modelWithLocation: [LocationResponseModel]) -> CafesListModule

    func makeCafesMap(using navigationController: UINavigationController,
                      modelWithCoordinates: [LocationResponseModel]) -> YMapModule

    func makeMenu(using navigationController: UINavigationController,
                  modelMenu: [OrderModel],
                  modelWithLocation: [LocationResponseModel]) -> MenuModule
    func makeOrder(using navigationController: UINavigationController,
                  order: [OrderModel]) -> OrderModule

}

struct ModuleFactory: ModuleFactoryProtocol {
    func makeRegistrationOrLogin(using navigationController: UINavigationController = UINavigationController()) -> RegistrationModule {
        let router = RegistrationRouter(navigationController: navigationController, moduleFactory: self)
        let view: RegistrationViewProtocol = RegistrationViewController()
        return RegistrationModule(view: view, router: router)
    }

    func makeCafesList(using navigationController: UINavigationController = UINavigationController(),
                       cafes: [CafeTableModelForUI], modelWithLocation: [LocationResponseModel]) -> CafesListModule {
        let interactor = CafesListInteractor()
        interactor.cafes = cafes
        interactor.modelWithCoordinates = modelWithLocation
        let router = CafesListRouter(navigationController: navigationController, moduleFactory: self)
        let view: CafesListViewProtocol = CafesListViewController()
        return CafesListModule(view: view, router: router, interactor: interactor)
    }

    func makeCafesMap(using navigationController: UINavigationController = UINavigationController(),
                      modelWithCoordinates: [LocationResponseModel]) -> YMapModule {
        let interactor = YMapInteractor()
        interactor.modelWithCoordinates = modelWithCoordinates
        let router = YMapRouter(navigationController: navigationController, moduleFactory: self)
        let view: YMapViewProtocol = YMapViewController()
        return YMapModule(view: view, router: router, interactor: interactor)
    }

    func makeMenu(using navigationController: UINavigationController = UINavigationController(),
                  modelMenu: [OrderModel], modelWithLocation: [LocationResponseModel]) -> MenuModule {
        let interactor = MenuInteractor()
        interactor.menuModel = modelMenu
        interactor.modelWithCoordinates = modelWithLocation
        let router = MenuRouter(navigationController: navigationController, moduleFactory: self)
        let view: MenuViewProtocol = MenuViewController()
        return MenuModule(view: view, router: router, interactor: interactor)
    }

    func makeOrder(using navigationController: UINavigationController = UINavigationController(),
                  order: [OrderModel]) -> OrderModule {
        let interactor = OrderInteractor()
        interactor.order = order
        let router = OrderRouter(navigationController: navigationController, moduleFactory: self)
        let view: OrderViewProtocol = OrderViewController()
        return OrderModule(view: view, router: router, interactor: interactor)
    }

}
