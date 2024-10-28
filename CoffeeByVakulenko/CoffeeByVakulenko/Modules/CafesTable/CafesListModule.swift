//
//  CafesListModule.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 12.02.2024.
//

import UIKit

final class CafesListModule {

    private var view: CafesListViewProtocol
    private var router: CafesListRouterProtocol
    private var interactor: CafesListInteractorProtocol
    private var presenter: CafesListPresenterProtocol

    init(view: CafesListViewProtocol = CafesListViewController(),
         router: CafesListRouterProtocol = CafesListRouter(),
         interactor: CafesListInteractorProtocol = CafesListInteractor(),
         presenter: CafesListPresenterProtocol = CafesListPresenter()) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.presenter = presenter
    }

}

extension CafesListModule: AppModule {
    func assemble() -> UIViewController? {
        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return view as? UIViewController
    }
}
