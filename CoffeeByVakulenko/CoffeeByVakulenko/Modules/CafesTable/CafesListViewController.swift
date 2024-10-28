//
//  CafesListViewController.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 12.02.2024.
//

import UIKit
import SnapKit


final class CafesListViewController: UIViewController, CafesListViewable {

    // MARK: - Public properties
    var presenter: CafesListPresenterProtocol = CafesListPresenter()
    var cafesModel: [CafeTableModelForUI] = []

    // MARK: - Private properties
    private let borderView: UIView = {
        let stroke = UIView()
        stroke.layer.borderWidth = 0.5
        stroke.layer.borderColor = Colors.navBackLineColor.cgColor
        return stroke
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.register(CafeCell.self, forCellReuseIdentifier: CafeCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        return tableView
    }()

    private lazy var mapButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 24.5
        button.layer.borderWidth = 2
        button.backgroundColor = Colors.buttonBackgroundColor
        button.titleLabel?.font = UIFont(name: "SFUIDisplay-Bold", size: 18)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("На карте", for: .normal)
        button.setTitleColor(Colors.buttonTitleOrCellBackGroundColor, for: .normal)
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(mapTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
        cafesModel = presenter.interactor.cafes
    }

    // MARK: - Private methods
    private func setupView() {
        [borderView, tableView, mapButton, Show.spinner].forEach { view.addSubview($0) }
        view.backgroundColor = .white
        title = "Ближайшие кофейни"
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
            make.bottom.equalTo(mapButton.snp.top).inset(10)
        }

        mapButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(47)
        }

    }

    // MARK: - Actions
    @objc private func mapTapped(_ sender: UIButton){
        presenter.showCafesOnMap()
    }

    @objc private func backAction(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
}



// MARK: - UITableViewDataSource
extension CafesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cafesModel.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CafeCell.identifier, for: indexPath) as? CafeCell else { return UITableViewCell() }
        cell.setup(cafe: cafesModel[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CafesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 77
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapAtCafe(cafesModel[indexPath.row])
    }
}


// MARK: - Error Handler
extension CafesListViewController: ErrorHandler {}
