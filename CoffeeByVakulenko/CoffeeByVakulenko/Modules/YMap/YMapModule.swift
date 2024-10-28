//
//  YMapModule.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 23.02.2024.
//

import UIKit

final class YMapModule {

    private var view: YMapViewProtocol
    private var router: YMapRouterProtocol
    private var interactor: YMapInteractorProtocol
    private var presenter: YMapPresenterProtocol

    init(view: YMapViewProtocol = YMapViewController(),
         router: YMapRouterProtocol = YMapRouter(),
         interactor: YMapInteractorProtocol = YMapInteractor(),
         presenter: YMapPresenterProtocol = YMapPresenter()) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.presenter = presenter
    }

}

extension YMapModule: AppModule {
    func assemble() -> UIViewController? {
        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return view as? UIViewController
    }
}
