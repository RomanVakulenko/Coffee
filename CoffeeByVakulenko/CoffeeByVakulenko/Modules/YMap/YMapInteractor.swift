//
//  YMapInteractor.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 23.02.2024.
//

import Foundation


final class YMapInteractor: YMapInteractable {

    weak var presenter: YMapPresenterProtocol?
    var menuService: MenuServiceProtocol
    var modelWithCoordinates: [LocationResponseModel] = []
    var menuWithFotoInFM: [MenuModel]?

    init(menuService: MenuServiceProtocol = MenuService()) {
        self.menuService = menuService
    }
}


extension YMapInteractor: YMapInteractorServiceRequester {

    func getMenuForCafeId(_ cafeId: Int) {
        let cafeMenuService = StandardNetworkService(resourcePath: "/location/" + "\(cafeId)" + "/menu")

        cafeMenuService.getMenuForChoosenCafe { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let menu):
                strongSelf.menuService.makeCoffeeModelWithFoto(for: menu) { result in
                    switch result {
                    case .success(let modelWithFoto):
                        strongSelf.presenter?.showMenu(modelWithFoto)
                    case .failure(let error):
                        strongSelf.presenter?.serviceFailedWithError(error)
                    }
                }
            case .failure(let error):
                strongSelf.presenter?.serviceFailedWithError(error)
            }
        }
    }

    func refreshMenu() {
        menuService.refreshStorage()
    }

}
