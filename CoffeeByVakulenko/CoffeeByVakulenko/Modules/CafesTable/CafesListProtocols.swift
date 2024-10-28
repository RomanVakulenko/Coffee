//
//  CafesListProtocols.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 12.02.2024.
//

import Foundation

// MARK: - Router
protocol CafesListRouterProtocol: AnyObject {
    func showCafeMenu(_ menu: [OrderModel], locations: [LocationResponseModel])
    func showCafesOnMapWith(_ locations: [LocationResponseModel])
}

// MARK: - View
typealias CafesListViewProtocol = CafesListViewable & ErrorHandler //& CafesListViewConfigurable

protocol CafesListViewable: AnyObject {
    var presenter: CafesListPresenterProtocol { get set }
    var cafesModel: [CafeTableModelForUI] { get set }
}

// MARK: - Presenter
typealias CafesListPresenterProtocol = CafesListPresentable & CafesListPresenterServiceInteractable & CafesListPresenterServiceHandler

protocol CafesListPresentable: AnyObject {
    var view: CafesListViewProtocol? { get set }
    var interactor: CafesListInteractorProtocol { get set }
    var router: CafesListRouterProtocol { get set }

    func showCafesOnMap()
}

protocol CafesListPresenterServiceInteractable: AnyObject {
    func showCafesOnMapWith(_ locations: [LocationResponseModel])
    func didTapAtCafe(_ cafe: CafeTableModelForUI)
    func showMenuOfCafe(_ menu: [OrderModel])
}

protocol CafesListPresenterServiceHandler: AnyObject {
    func serviceFailedWithError(_ error: Error)
}

protocol CafeTableViewCellProtocol: AnyObject {
    func setup(cafe: CafeTableModelForUI)
}


// MARK: - Interactor
typealias CafesListInteractorProtocol = CafesListInteractable & CafesListInteractorServiceRequester

protocol CafesListInteractable: AnyObject {
    var presenter: CafesListPresenterProtocol? { get set }
    var cafes: [CafeTableModelForUI] { get set }
    var modelWithCoordinates: [LocationResponseModel] { get set }

    func makeModelWithCoordinates()
}

protocol CafesListInteractorServiceRequester: AnyObject {
    func getMenuForCafeId(_ cafeId: Int)
}


