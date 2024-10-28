//
//  MenuModule.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 24.02.2024.
//

import UIKit

final class MenuModule {

    private var view: MenuViewProtocol
    private var router: MenuRouterProtocol
    private var interactor: MenuInteractorProtocol
    var presenter: MenuPresenterProtocol

    init(view: MenuViewProtocol = MenuViewController(),
         router: MenuRouterProtocol = MenuRouter(),
         interactor: MenuInteractorProtocol = MenuInteractor(),
         presenter: MenuPresenterProtocol = MenuPresenter()) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.presenter = presenter
    }

}

extension MenuModule: AppModule {
    func assemble() -> UIViewController? {
        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return view as? UIViewController
    }
}
