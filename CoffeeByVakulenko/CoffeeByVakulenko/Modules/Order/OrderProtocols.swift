//
//  OrderProtocols.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 28.02.2024.
//

import Foundation


// MARK: - Router
protocol OrderRouterProtocol: AnyObject {
    func payFor(_ order: [OrderModel])
}
// MARK: - View
typealias OrderViewProtocol = OrderViewable & ErrorHandler //& OrderViewConfigurable

protocol OrderViewable: AnyObject {
    var presenter: OrderPresenterProtocol { get set }
    var orderModel: [OrderModel] { get set }
}

// MARK: - Presenter
typealias OrderPresenterProtocol = OrderPresentable & OrderPresenterServiceInteractable //& OrderPresenterServiceHandler

protocol OrderPresentable: AnyObject {
    var view: OrderViewProtocol? { get set }
    var interactor: OrderInteractorProtocol { get set }
    var router: OrderRouterProtocol { get set }

    func payForOrder(_ order: [OrderModel])
}

protocol OrderPresenterServiceInteractable: AnyObject {
    func didTapPay(_ order: [OrderModel])
}

protocol OrderTableViewCellProtocol: AnyObject {
    func setup(order: OrderModel, at indexPath: IndexPath)
}


// MARK: - Interactor
typealias OrderInteractorProtocol = OrderInteractable & OrderInteractorServiceRequester

protocol OrderInteractable: AnyObject {
    var presenter: OrderPresenterProtocol? { get set }
    var order: [OrderModel] { get set }
}

protocol OrderInteractorServiceRequester: AnyObject {
    func payFor(_ order: [OrderModel])
}


