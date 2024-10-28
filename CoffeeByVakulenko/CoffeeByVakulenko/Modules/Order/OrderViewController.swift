//
//  OrderViewController.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 28.02.2024.
//

import UIKit
import SnapKit

// MARK: - OrderViewController
final class OrderViewController: UIViewController, OrderViewable {

    // MARK: - Public properties
    var presenter: OrderPresenterProtocol = OrderPresenter()
    var orderModel: [OrderModel] = []

    // MARK: - Private properties
    private let borderView: UIView = {
        let stroke = UIView()
        stroke.layer.borderWidth = 0.5
        stroke.layer.borderColor = Colors.navBackLineColor.cgColor
        return stroke
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        return tableView
    }()

    private lazy var thanksLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.labelcolor
        label.text = """
                    Время ожидания заказа
                    15 минут!
                    Спасибо, что выбрали нас!
                    """
        label.font = UIFont(name: "SFUIDisplay-Medium", size: 24)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 24.5
        button.layer.borderWidth = 2
        button.backgroundColor = Colors.buttonBackgroundColor
        button.titleLabel?.font = UIFont(name: "SFUIDisplay-Bold", size: 18)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(Colors.buttonTitleOrCellBackGroundColor, for: .normal)
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(payTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
        orderModel = presenter.interactor.order
    }

    // MARK: - Private methods
    private func setupView() {
        [borderView, tableView, thanksLabel, payButton].forEach { view.addSubview($0) }
        view.backgroundColor = .white
        title = "Ваш заказ"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"), //или named: "back24x24" in assets
            style: .plain,
            target: self,
            action: #selector(backAction))

    }

    private func layout() {
        borderView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(2)
        }

        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(15) //визуально столько, ширина же 349 не совпадает с визуалом (в фигме ширина экрана, видимо меньше, чем у iPhone14)
            make.bottom.equalTo(payButton.snp.top).inset(10)
        }

        thanksLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(456)
            make.height.equalTo(87)
        }

        payButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(47)
        }

    }

    // MARK: - Actions
    @objc private func payTapped(_ sender: UIButton){
        print("Do pay")
    }

    @objc private func backAction(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
}



// MARK: - UITableViewDataSource
extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderModel.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as? OrderCell else { return UITableViewCell() }
        cell.setup(order: orderModel[indexPath.row], at: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension OrderViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 77
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapPay(orderModel)
    }
}


// MARK: - Error Handler
extension OrderViewController: ErrorHandler {}
