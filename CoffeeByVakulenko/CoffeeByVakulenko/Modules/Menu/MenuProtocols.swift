//
//  MenuProtocols.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 24.02.2024.
//

import Foundation


// MARK: - Router
protocol MenuRouterProtocol: AnyObject {
    func showTheOrder(_ menu: [OrderModel])
}

// MARK: - View
typealias MenuViewProtocol = MenuViewable //& CafesListViewConfigurable

protocol MenuViewable: AnyObject {
    var presenter: MenuPresenterProtocol { get set }
    var modelWithAddedQuantity: [OrderModel] { get set }
}

// MARK: - Presenter
typealias MenuPresenterProtocol = MenuPresentable & MenuPresenterInteractable //& MenuPresenterServiceHandler

protocol MenuPresentable: AnyObject {
    var view: MenuViewProtocol? { get set }
    var interactor: MenuInteractorProtocol { get set }
    var router: MenuRouterProtocol { get set }
}

protocol MenuPresenterInteractable: AnyObject {
    func assembleOrderWith(order: [OrderModel])
}


protocol MenuCellProtocol: AnyObject {
    func setup(menu: OrderModel, at indexPath: IndexPath)
}


// MARK: - Interactor
typealias MenuInteractorProtocol = MenuInteractable //& MenuInteractorServiceRequester

protocol MenuInteractable: AnyObject {
    var presenter: MenuPresenterProtocol? { get set }
    var modelWithCoordinates: [LocationResponseModel] { get set }
    var menuModel: [OrderModel] { get set }
}


