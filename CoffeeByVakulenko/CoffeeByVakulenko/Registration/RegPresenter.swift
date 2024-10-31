//
//  RegistrationPresenter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 06.02.2024.
//  
//

import Foundation


// MARK: - RegistrationPresenter
final class RegistrationPresenter: RegistrationPresentable {
    
    // MARK: - Properties
    weak var view: RegistrationViewProtocol?
    var interactor: RegistrationInteractorProtocol
    var router: RegistrationRouterProtocol
    
    // MARK: - Public API
    init(view: RegistrationViewProtocol? = nil,
         interactor: RegistrationInteractorProtocol = RegistrationInteractor(),
         router: RegistrationRouterProtocol = RegistrationRouter()) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}


// MARK: - View Configuration
extension RegistrationPresenter: RegistrationPresenterViewConfiguration {

    func setUsernameIfRegisteredAndAuthentificatedEarlier() {
        //можно просто по токену
        if interactor.doRememberUsername && interactor.isAuthenticated() {
            view?.presetUsername(interactor.usernameFromStorage)
        }
    }
}

// MARK: - Interactor
extension RegistrationPresenter: RegistrationPresenterServiceInteractable {
    
    private var username: String? { view?.usernameText }
    private var password: String? { view?.passwordText }
    
    private var credentialsAreValid: Bool {
        username?.isEmpty == false && password?.isEmpty == false
    }
    private func validateCredentials() -> Bool {
        guard credentialsAreValid else {
            view?.handleError(title: "Error", message: "Fill both fields")
            return false
        }
        return true
    }
    
    func performRegister() {
        guard validateCredentials() else { return }
        interactor.register(username: username!, password: password!)
    }
    
    func performLogin() {
        guard validateCredentials() else { return }
        interactor.loginWith(username: username!, password: password!)
    }
}

// MARK: - Service Handler
extension RegistrationPresenter: RegistrationPresenterServiceHandler {

    func didRegister() {
        view?.setupLoginView()
        Show.spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Show.spinner.stopAnimating()
            self.view?.loginLayout()
            self.view?.showRegistrationAlert()
        }
    }

    func didLogin() { //успешно прошли аутентификацию и
        interactor.getLocations(username: username!, password: password!) // получаем локации кафе с помощью токена
    }

    func gotLocations(_ cafes: [CafeTableModelForUI], locations: [LocationResponseModel]) {
        Show.spinner.stopAnimating()
        router.showCafesListWith(cafes, locations: locations) //открываем экран с таблицей кафе
    }
    
    func serviceFailedWithError(_ error: Error) {
        Show.spinner.stopAnimating()
        view?.handleError(title: "Error", message: error.localizedDescription)
    }
}

