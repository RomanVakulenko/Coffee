//
//  MenuPresenter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 24.02.2024.
//

import Foundation


final class MenuPresenter: MenuPresentable {

    weak var view: MenuViewProtocol?
    var interactor: MenuInteractorProtocol
    var router: MenuRouterProtocol

    init(view: MenuViewProtocol? = nil,
         interactor: MenuInteractorProtocol = MenuInteractor(),
         router: MenuRouterProtocol = MenuRouter()) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}


extension MenuPresenter: MenuPresenterInteractable {

    func assembleOrderWith(order: [OrderModel]) {
        router.showTheOrder(order)
    }
}
