//
//  CafesListInteractor.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 12.02.2024.
//

import Foundation


// MARK: - CafesListInteractor
final class CafesListInteractor {
    // MARK: - Public properties
    weak var presenter: CafesListPresenterProtocol?
    var cafes: [CafeTableModelForUI] = []
    var modelWithCoordinates: [LocationResponseModel] = []
    var menuWithFotoInFM: [MenuModel] = []

    // MARK: - Private properties
    private let menuService: MenuServiceProtocol
    private let userDefaults: CoffeeUserDefaults
    private let mapper = DataMapper()

    // MARK: - Init
    init(menuService: MenuServiceProtocol = MenuService(),
         userDefaults: CoffeeUserDefaults = .shared) {
        self.menuService = menuService
        self.userDefaults = userDefaults
    }
}


// MARK: - CafesListInteractable
extension CafesListInteractor: CafesListInteractable {
    func makeModelWithCoordinates() {
        guard let locationsData = userDefaults.locations else { return }
        mapper.decode(from: locationsData, toStruct: [LocationResponseModel].self) { result in
            switch result {
            case .success(let locations):
                self.modelWithCoordinates = locations
                self.presenter?.showCafesOnMapWith(locations)
            case .failure(let error):
                self.presenter?.serviceFailedWithError(error)
            }
        }
    }
}

// MARK: - CafesListInteractorServiceRequester
extension CafesListInteractor: CafesListInteractorServiceRequester {

    func getMenuForCafeId(_ cafeId: Int) {
        let cafeMenuService = StandardNetworkService(resourcePath: "/location/" + "\(cafeId)" + "/menu")
        Show.spinner.startAnimating()
        cafeMenuService.getMenuForChoosenCafe { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let menu):
                strongSelf.menuService.makeCoffeeModelWithFoto(for: menu) { result in
                    switch result {
                    case .success(let modelWithFoto):
                        strongSelf.presenter?.showMenuOfCafe(modelWithFoto)

                    case .failure(let error):
                        strongSelf.presenter?.serviceFailedWithError(error)
                    }
                }
            case .failure(let error):
                strongSelf.presenter?.serviceFailedWithError(error)
            }
        }
    }
}
