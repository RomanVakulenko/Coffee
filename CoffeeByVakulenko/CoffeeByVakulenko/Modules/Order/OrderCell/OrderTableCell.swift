//
//  OrderCellProtocol.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 28.02.2024.
//

import UIKit
import SnapKit


protocol OrderCellDelegateProtocol: AnyObject {
    func updateAmountOfCoffee(newAmount: Int, indexPath: IndexPath )
}


final class OrderCell: UITableViewCell, OrderTableViewCellProtocol {

    weak var delegate: OrderCellDelegateProtocol?
    var indexPath: IndexPath?

    // MARK: - Private properties
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.buttonTitleOrCellBackGroundColor
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowRadius = 2
        return view
    }()

    private lazy var coffeeName: UILabel = {
        let label = UILabel()
        label.textColor = Colors.labelcolor
        label.font = UIFont(name: "SFUIDisplay-Bold", size: 18)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private lazy var priceLabel: UILabel = {
        var label = UILabel()
        label.textColor = Colors.backTextColor
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        return label
    }()

    private let minusImage: UIButton = {
        let minus = UIButton()
        minus.backgroundColor = .clear
        minus.tintColor = Colors.labelcolor
        minus.setImage(UIImage(systemName: "minus"), for: .normal)
        minus.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        minus.isUserInteractionEnabled = true
        return minus
    }()

    private lazy var amountLabel: UILabel = {
        let textField = UILabel()
        textField.text = "0"
        textField.textColor = Colors.labelcolor
        textField.font = UIFont(name: "SFUIDisplay-Regular", size: 16)
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        return textField
    }()

    private let plusImage: UIButton = {
        let plus = UIButton()
        plus.backgroundColor = .clear
        plus.tintColor = Colors.labelcolor
        plus.setImage(UIImage(systemName: "plus"), for: .normal)
        plus.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        plus.isUserInteractionEnabled = true
        return plus
    }()

    private let whiteSpaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()


    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func setup(order: OrderModel, at indexPath: IndexPath) {
        self.indexPath = indexPath

        self.coffeeName.text = order.coffeeName
        self.priceLabel.text = "\(order.price) руб"
        self.amountLabel.text = String(order.quantity)
    }

    @objc func minusTapped(_ sender: UIButton) {
        var newAmount = Int(amountLabel.text ?? "") ?? 0
        guard let indexPath = self.indexPath else { return }
        if newAmount >= 0 {
            newAmount -= 1
            amountLabel.text = String(newAmount)
            self.delegate?.updateAmountOfCoffee(newAmount: newAmount, indexPath: indexPath)
        }

    }

    @objc func plusTapped(_ sender: UIButton) {
        var newAmount = Int(amountLabel.text ?? "") ?? 0
        newAmount += 1
        guard let indexPath else { return }
        amountLabel.text = String(newAmount)
        self.delegate?.updateAmountOfCoffee(newAmount: newAmount, indexPath: indexPath)
    }

    // MARK: - Private methods
    private func setupView() {
        [coffeeName, priceLabel, minusImage, amountLabel, plusImage].forEach { baseView.addSubview($0) }
        [baseView, whiteSpaceView].forEach { contentView.addSubview($0) }
        contentView.backgroundColor = .clear
    }

    private func layout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        baseView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.top.equalTo(contentView.snp.top)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(71)
        }

        whiteSpaceView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.top.equalTo(baseView.snp.bottom)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(6)
        }

        coffeeName.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading).offset(10)
            make.top.equalTo(baseView.snp.top).offset(14)
            make.width.equalTo(253)
            make.height.equalTo(21)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading).offset(10)
            make.top.equalTo(coffeeName.snp.bottom).offset(6)
            make.width.equalTo(253)
            make.height.equalTo(21)
        }

        minusImage.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading).offset(273)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

        amountLabel.snp.makeConstraints { make in
            make.leading.equalTo(minusImage.snp.trailing).offset(9)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(10)
            make.height.equalTo(19)
        }

        plusImage.snp.makeConstraints { make in
            make.leading.equalTo(amountLabel.snp.trailing).offset(9)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }
}



