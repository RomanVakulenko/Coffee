//
//  RegModule.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 07.02.2024.
//

import UIKit

final class RegistrationModule {

    private var view: RegistrationViewProtocol
    private var router: RegistrationRouterProtocol
    private var interactor: RegistrationInteractorProtocol
    private var presenter: RegistrationPresenterProtocol

    init(view: RegistrationViewProtocol = RegistrationViewController(),
         router: RegistrationRouterProtocol = RegistrationRouter(),
         interactor: RegistrationInteractorProtocol = RegistrationInteractor(),
         presenter: RegistrationPresenterProtocol = RegistrationPresenter()) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.presenter = presenter
    }

}

extension RegistrationModule: AppModule {
    func assemble() -> UIViewController? {
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        view.presenter = presenter

        return view as? UIViewController
    }
}
