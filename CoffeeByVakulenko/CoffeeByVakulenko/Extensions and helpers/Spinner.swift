//
//  Spinner.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 06.02.2024.
//

import Foundation
import UIKit

enum Show {
    static let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = Colors.backTextColor
        spinner.layer.cornerRadius = 8
        spinner.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                 y: (UIScreen.main.bounds.height / 2) + 16)
        return spinner
    }()
}
