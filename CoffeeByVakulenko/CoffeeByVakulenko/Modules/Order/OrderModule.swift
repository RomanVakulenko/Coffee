//
//  OrderModule.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 28.02.2024.
//

import UIKit

final class OrderModule {

    private var view: OrderViewProtocol
    private var router: OrderRouterProtocol
    var interactor: OrderInteractorProtocol
    private var presenter: OrderPresenterProtocol

    init(view: OrderViewProtocol = OrderViewController(),
         router: OrderRouterProtocol = OrderRouter(),
         interactor: OrderInteractorProtocol = OrderInteractor(),
         presenter: OrderPresenterProtocol = OrderPresenter()) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.presenter = presenter
    }

}

extension OrderModule: AppModule {
    func assemble() -> UIViewController? {
        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return view as? UIViewController
    }
}
