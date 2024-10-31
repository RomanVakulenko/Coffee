//
//  RegistrationInteractor.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 06.02.2024.
//  
//

import Foundation
import Alamofire

// MARK: - Registration & LoginInteractor
final class RegistrationInteractor: RegistrationInteractable {

    // MARK: - Public properties
    weak var presenter: RegistrationPresenterProtocol?
    var cafes: [CafeTableModelForUI] = []

    // MARK: - Private properties
    private let registerService, loginService, cafeService: StandardNetworkService
    private let userDefaults: CoffeeUserDefaults
    private let keychain: CoffeeKeychain
    private let distanceService: DistanceServiceProtocol
    private let mapper = DataMapper()

    // MARK: - Init
    init(registerService: StandardNetworkService = StandardNetworkService(resourcePath: "/auth/register"),
         loginService: StandardNetworkService = StandardNetworkService(resourcePath: "/auth/login"),
         cafeService: StandardNetworkService = StandardNetworkService(resourcePath: "/locations", authenticated: true),
         userDefaults: CoffeeUserDefaults = .shared,
         keychain: CoffeeKeychain = .shared,
         distanceService: DistanceServiceProtocol = DistanceService()) {
        self.registerService = registerService
        self.loginService = loginService
        self.cafeService = cafeService
        self.userDefaults = userDefaults
        self.keychain = keychain
        self.distanceService = distanceService
    }

    // MARK: - Private methods
    private func makeUIModelWithDistanceFor(_ locations: [LocationResponseModel]) -> [CafeTableModelForUI] {
        distanceService.makeUIModelWithDistance(
            decodedModel: locations,
            locationManager: distanceService.locationManager) { cafesForUI in
                self.cafes = cafesForUI
            }
        return self.cafes
    }
}


// MARK: - RegistrationInteractorCredentialsHandler
extension RegistrationInteractor: RegistrationInteractorCredentialsHandler {

    var doRememberUsername: Bool { userDefaults.isUsernameStored ?? true }
    var usernameFromStorage: String? { userDefaults.username }

    func storePassword(password: String?) {
        keychain.password = password
    }

    func isAuthenticated() -> Bool {
        return keychain.token != nil  // Проверяем наличие токена в Keychain
    }
}

// MARK: - RegistrationInteractorServiceRequester
extension RegistrationInteractor: RegistrationInteractorServiceRequester {

    func register(username: String, password: String) {
        guard let hashedPasssword = Crypto.hash(message: password) else {
            fatalError("Unable to hash password")
        } //для дополнительной безопасности (обычно сервер сам хэширует пароль)

        let cache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        URLCache.shared = cache//то, что отправит нам сервер обычно сохраняется в кеше и к ним можно получить доступ (небезопасно), потому "отключаем"

        let parameters: [String: Any] = [
            "login":   username,
            "password": hashedPasssword
        ]
        registerService.postWith(parameters) { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .failure(let error):
                    strongSelf.presenter?.serviceFailedWithError(error)

                case .success(_):
                    strongSelf.userDefaults.username = username
                    strongSelf.userDefaults.isUsernameStored = true
                    strongSelf.storePassword(password: hashedPasssword)
                    strongSelf.presenter?.didRegister()
                }
        }
    }

    func loginWith(username: String, password: String) {
        guard let hashedPassword = Crypto.hash(message: password) else {
            fatalError("Unable to hash password")
        }

        // Сравниваем хешированный введённый пароль с сохранённым в Keychain
        guard hashedPassword == keychain.password else {
            // Создаём ошибку для неверного пароля
            let error = NSError(domain: "LoginErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Пароль неверный"])
            self.presenter?.serviceFailedWithError(error)
            return
        }

        let parameters: [String: Any] = [
            "login": username,
            "password": hashedPassword
        ]

        loginService.postWith(parameters) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.presenter?.serviceFailedWithError(error)

            case .success(let loginModel):
                strongSelf.keychain.token = loginModel.token
                strongSelf.presenter?.didLogin()
            }
        }
    }


    func getLocations(username: String, password: String) {
        if keychain.password != nil {

            cafeService.getLocationsOfCafes() { [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case .failure(let error):
                    strongSelf.presenter?.serviceFailedWithError(error)

                case .success(let locations):
                    strongSelf.cafes = strongSelf.makeUIModelWithDistanceFor(locations)
                    do {
                        strongSelf.userDefaults.locations = try strongSelf.mapper.encode(from: locations)
                        strongSelf.presenter?.gotLocations(strongSelf.cafes, locations: locations)
                    } catch {
                        strongSelf.presenter?.serviceFailedWithError(MapperError.failParsed(reason: "Encoding error"))
                    }
                }
            }
        }
    }
}

