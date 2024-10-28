//
//  MenuCell.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 26.02.2024.
//

import UIKit
import SnapKit

protocol MenuCellDelegateProtocol: AnyObject {
    func updateAmountOfCoffee(newAmount: Int, indexPath: IndexPath )
}


final class MenuCell: UICollectionViewCell, MenuCellProtocol {

    weak var delegate: MenuCellDelegateProtocol?
    var indexPath: IndexPath?

    private lazy var baseView: UIView = {
        let baseView = UIView()
        baseView.frame = CGRect(x: 0, y: 0, width: 165, height: 205)

        let shadows = UIView()
        shadows.frame = baseView.bounds
        shadows.clipsToBounds = false
        baseView.addSubview(shadows)

        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 5)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 2
        layer0.shadowOffset = CGSize(width: 0, height: 2)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)

        let shapes = UIView()
        shapes.frame = baseView.bounds
        shapes.clipsToBounds = true
        baseView.addSubview(shapes)

        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)

        shapes.layer.cornerRadius = 5

        return baseView
    }()

    private let coffeeImage: UIImageView = {
        let coffeeImage = UIImageView()
        coffeeImage.image = UIImage(systemName: "")
        coffeeImage.layer.cornerRadius = 5
        coffeeImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Закругление верхних углов
        coffeeImage.clipsToBounds = true
        return coffeeImage
    }()

    private lazy var nameOfCoffee: UILabel = {
        let name = UILabel()
        name.textColor = Colors.backTextColor
        name.font = UIFont(name: "SFUIDisplay-Medium", size: 15)
        return name
    }()

    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = Colors.labelcolor
        priceLabel.font = UIFont(name: "SFUIDisplay-Bold", size: 14)
        priceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return priceLabel
    }()

    private let minusImage: UIButton = {
        let minus = UIButton()
        minus.backgroundColor = .clear
        minus.tintColor = Colors.buttonTitleOrCellBackGroundColor
        minus.setImage(UIImage(systemName: "minus"), for: .normal)
        minus.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        minus.isUserInteractionEnabled = true
        return minus
    }()

    private lazy var amountLabel: UILabel = {
        let textField = UILabel()
        textField.text = "0"
        textField.textColor = Colors.labelcolor
        textField.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        return textField
    }()

    private let plusImage: UIButton = {
        let plus = UIButton()
        plus.backgroundColor = .clear
        plus.tintColor = Colors.buttonTitleOrCellBackGroundColor
        plus.setImage(UIImage(systemName: "plus"), for: .normal)
        plus.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        plus.isUserInteractionEnabled = true
        return plus
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public methods

    func setup(menu: OrderModel, at indexPath: IndexPath) {
        self.indexPath = indexPath

        coffeeImage.image = UIImage(contentsOfFile: menu.imageURL) //тут надо подставлять картинку
        nameOfCoffee.text = menu.coffeeName
        priceLabel.text = String(menu.price) + " руб"
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
        [coffeeImage, nameOfCoffee, priceLabel, minusImage, amountLabel, plusImage].forEach { baseView.addSubview($0) }
        contentView.addSubview(baseView)
    }


    private func setupLayout() {

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        baseView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(4)
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(165)
            make.height.equalTo(205)
        }

        coffeeImage.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading)
            make.top.equalTo(baseView.snp.top)
            make.width.equalTo(165)
            make.height.equalTo(137)
        }

        nameOfCoffee.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading).offset(11)
            make.top.equalTo(coffeeImage.snp.bottom).offset(10)
            make.width.equalTo(165)
            make.height.equalTo(18)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading).offset(11)
            make.top.equalTo(nameOfCoffee.snp.bottom).offset(12)
            make.width.equalTo(70)
            make.height.equalTo(17)
        }

        minusImage.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading).offset(82)
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

        amountLabel.snp.makeConstraints { make in
            make.leading.equalTo(minusImage.snp.trailing).offset(9)
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.width.equalTo(10)
            make.height.equalTo(17)
        }

        plusImage.snp.makeConstraints { make in
            make.leading.equalTo(amountLabel.snp.trailing).offset(9) //152 - 16 - 82(до минуса) - 9 (до кол-ва) - 10(ширКолва)
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

    }

}
