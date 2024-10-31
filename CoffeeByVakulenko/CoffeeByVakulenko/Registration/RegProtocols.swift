//
//  RegistrationContract.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 06.02.2024.
//  
//

import Foundation


// MARK: - Router
protocol RegistrationRouterProtocol: AnyObject {
    func showCafesListWith(_ cafes: [CafeTableModelForUI],
                           locations: [LocationResponseModel])
}

// MARK: - View
typealias RegistrationViewProtocol = RegistrationViewable & RegistrationViewConfigurable & ErrorHandler

protocol RegistrationViewable: AnyObject {
    var presenter: RegistrationPresenterProtocol { get set }
}

protocol RegistrationViewConfigurable: AnyObject {
    var usernameText: String? { get }
    var passwordText: String? { get }

    func presetUsername(_ username: String?)
    func setupLoginView()
    func loginLayout()
    func showRegistrationAlert()
}

// MARK: - Presenter
typealias RegistrationPresenterProtocol = RegistrationPresentable & RegistrationPresenterViewConfiguration & RegistrationPresenterServiceInteractable & RegistrationPresenterServiceHandler

protocol RegistrationPresentable: AnyObject {
    var view: RegistrationViewProtocol? { get set }
    var interactor: RegistrationInteractorProtocol { get set }
    var router: RegistrationRouterProtocol { get set }
}

protocol RegistrationPresenterViewConfiguration: AnyObject {
    func setUsernameIfRegisteredAndAuthentificatedEarlier()
}

protocol RegistrationPresenterServiceInteractable: AnyObject {
    func performLogin()
    func performRegister()
}

protocol RegistrationPresenterServiceHandler: AnyObject {
    func didRegister()
    func didLogin()
    func gotLocations(_ cafes: [CafeTableModelForUI], locations: [LocationResponseModel])
    func serviceFailedWithError(_ error: Error)
}

// MARK: - Interactor
typealias RegistrationInteractorProtocol = RegistrationInteractable & RegistrationInteractorServiceRequester & RegistrationInteractorCredentialsHandler

protocol RegistrationInteractable: AnyObject {
    var presenter: RegistrationPresenterProtocol? { get set }
}

protocol RegistrationInteractorServiceRequester: AnyObject {
    func register(username: String, password: String)
    func loginWith(username: String, password: String)
    func getLocations(username: String, password: String)
}

protocol RegistrationInteractorCredentialsHandler: AnyObject {
    var doRememberUsername: Bool { get }
    var usernameFromStorage: String? { get }

    func storePassword(password: String?)
    func isAuthenticated() -> Bool
}




