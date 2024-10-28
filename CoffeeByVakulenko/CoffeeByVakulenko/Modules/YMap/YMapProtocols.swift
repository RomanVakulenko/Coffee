//
//  YMapProtocols.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 23.02.2024.
//

import Foundation


// MARK: - Router
protocol YMapRouterProtocol: AnyObject {
    func showCafeMenu(_ menu: [OrderModel], locations: [LocationResponseModel])
}

// MARK: - View
typealias YMapViewProtocol = YMapViewable & ErrorHandler //& CafesListViewConfigurable

protocol YMapViewable: AnyObject {
    var presenter: YMapPresenterProtocol { get set }
    var modelWithCoordinates: [LocationResponseModel] { get set }
}

// MARK: - Presenter
typealias YMapPresenterProtocol = YMapPresentable & YMapPresenterServiceInteractable & YMapPresenterServiceHandler

protocol YMapPresentable: AnyObject {
    var view: YMapViewProtocol? { get set }
    var interactor: YMapInteractorProtocol { get set }
    var router: YMapRouterProtocol { get set }
}

protocol YMapPresenterServiceInteractable: AnyObject {
    func didTapAtCafe(_ cafeId: Int)
    func showMenu(_ menu: [OrderModel])
    func backButtonDidTap()

}

protocol YMapPresenterServiceHandler: AnyObject {
    func serviceFailedWithError(_ error: Error)
}

// MARK: - Interactor
typealias YMapInteractorProtocol = YMapInteractable & YMapInteractorServiceRequester

protocol YMapInteractable: AnyObject {
    var presenter: YMapPresenterProtocol? { get set }
    var modelWithCoordinates: [LocationResponseModel] { get set }
}

protocol YMapInteractorServiceRequester: AnyObject {
    func getMenuForCafeId(_ id: Int)
    func refreshMenu()
}


