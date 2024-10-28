//
//  OrderPresenter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 28.02.2024.
//

import Foundation


final class OrderPresenter: OrderPresentable {

    weak var view: OrderViewProtocol?
    var interactor: OrderInteractorProtocol
    var router: OrderRouterProtocol

    init(view: OrderViewProtocol? = nil,
         interactor: OrderInteractorProtocol = OrderInteractor(),
         router: OrderRouterProtocol = OrderRouter()) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func payForOrder(_ order: [OrderModel]) {
        router.payFor(order)
    }
}


extension OrderPresenter: OrderPresenterServiceInteractable {

    func didTapPay(_ order: [OrderModel]) {
        interactor.payFor(order)
    }
}
