//
//  MenuViewController.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 24.02.2024.
//

import UIKit
import SnapKit


final class MenuViewController: UIViewController, MenuViewable {

    // MARK: - Public properties
    var presenter: MenuPresenterProtocol = MenuPresenter()
    var menuModel: [OrderModel] = []
    var modelWithAddedQuantity: [OrderModel] = [] //в которую запишем набранные позиции

    // MARK: - Private properties
    private let borderView: UIView = {
        let stroke = UIView()
        stroke.layer.borderWidth = 0.5
        stroke.layer.borderColor = Colors.navBackLineColor.cgColor
        return stroke
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 24.5
        button.layer.borderWidth = 2
        button.backgroundColor = Colors.buttonBackgroundColor
        button.titleLabel?.font = UIFont(name: "SFUIDisplay-Bold", size: 18)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Перейти к оплате", for: .normal)
        button.setTitleColor(Colors.buttonTitleOrCellBackGroundColor, for: .normal)
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(payTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        menuModel = presenter.interactor.menuModel
        modelWithAddedQuantity = menuModel
    }

    // MARK: - Private methods
    private func setupView() {
        [borderView, collectionView, payButton].forEach { view.addSubview($0) }
        view.addSubview(collectionView)
        view.backgroundColor = .white
        title = "Меню"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"), //или named: "back24x24" in assets
            style: .plain,
            target: self,
            action: #selector(backAction))
    }

    private func setupLayout() {
        borderView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.height.equalTo(2)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16) //визуально столько, ширина же 349 не совпадает с визуалом (в фигме ширина экрана, видимо меньше, чем у iPhone14)
            make.bottom.equalTo(payButton.snp.top)
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
        presenter.assembleOrderWith(order: modelWithAddedQuantity)
    }

    @objc private func backAction(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - UICollectionViewDataSource
extension MenuViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuModel.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MenuCell.identifier,
            for: indexPath) as? MenuCell else {
            return UICollectionViewCell()
        }

        let model = menuModel[indexPath.item]
        cell.setup(menu: model, at: indexPath)
        cell.isSelected = false
        
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MenuViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let width: CGFloat = (collectionView.frame.size.width - space) / 2.0
        let height: CGFloat = 205
        return CGSize(width: width, height: height)
    }
    /// между рядами-строками для вертикальной коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}


// MARK: - Error Handler
extension MenuViewController: ErrorHandler {}

extension MenuViewController: MenuCellDelegateProtocol {
    func updateAmountOfCoffee(newAmount: Int, indexPath: IndexPath) {

        modelWithAddedQuantity[indexPath.item].quantity = newAmount
//        #error("тут получаем обновленную модель с колличеством кофе - надо передавать в презентер, в итератор, и на страницу заказа")
        print(modelWithAddedQuantity)
    }
}
