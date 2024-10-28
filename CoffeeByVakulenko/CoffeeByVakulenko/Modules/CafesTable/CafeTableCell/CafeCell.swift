//
//  CafeCell.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 18.02.2024.
//

import UIKit
import SnapKit

final class CafeCell: UITableViewCell, CafeTableViewCellProtocol {
    
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

    private lazy var cafeName: UILabel = {
        let label = UILabel()
        label.textColor = Colors.labelcolor
        label.font = UIFont(name: "SFUIDisplay-Bold", size: 18)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        var label = UILabel()
        label.textColor = Colors.backTextColor
        label.font = UIFont(name: "SFUIDisplay-Regular", size: 14)
        return label
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
    func setup(cafe: CafeTableModelForUI) {
        self.cafeName.text = cafe.cafeName
        self.distanceLabel.text = cafe.distanceLabel
    }
    
    
    // MARK: - Private methods
    private func setupView() {
        [cafeName, distanceLabel].forEach { baseView.addSubview($0) }
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

        cafeName.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading).offset(10)
            make.top.equalTo(baseView.snp.top).offset(14)
            make.width.equalTo(253)
            make.height.equalTo(21)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(baseView.snp.leading).offset(10)
            make.top.equalTo(cafeName.snp.bottom).offset(6)
            make.width.equalTo(253)
            make.height.equalTo(21)
        }
    }
}



