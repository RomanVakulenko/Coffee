//
//  CafesListPresenter.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 12.02.2024.
//

import Foundation


// MARK: - CafesListPresenter
final class CafesListPresenter: CafesListPresentable {

    // MARK: - Public properties
    weak var view: CafesListViewProtocol?
    var interactor: CafesListInteractorProtocol
    var router: CafesListRouterProtocol

    // MARK: - Init
    init(view: CafesListViewProtocol? = nil,
         interactor: CafesListInteractorProtocol = CafesListInteractor(),
         router: CafesListRouterProtocol = CafesListRouter()) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    // MARK: - Public methods
    func showCafesOnMap() {
        interactor.makeModelWithCoordinates()
    }
}

// MARK: - CafesListPresenterServiceInteractable
extension CafesListPresenter: CafesListPresenterServiceInteractable {

    func didTapAtCafe(_ cafe: CafeTableModelForUI) {
        for cafeWithID in interactor.modelWithCoordinates {
            if cafe.cafeName == cafeWithID.name {
                interactor.getMenuForCafeId(cafeWithID.id)
            }
        }
    }

    func showCafesOnMapWith(_ locations: [LocationResponseModel]) {
        router.showCafesOnMapWith(locations)
    }

    func showMenuOfCafe(_ menu: [OrderModel]) {
        Show.spinner.stopAnimating()
        router.showCafeMenu(menu, locations: interactor.modelWithCoordinates)
    }
}

// MARK: - CafesListPresenterServiceHandler
extension CafesListPresenter: CafesListPresenterServiceHandler {
    func serviceFailedWithError(_ error: Error) {
        view?.handleError(title: "Error", message: String(describing: error))
    }
}
