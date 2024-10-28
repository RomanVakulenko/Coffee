//
//  YBaseMapView.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 22.02.2024.
//
import UIKit
import YandexMapsMobile

class YBaseMapView: UIView {

    @objc public var mapView: YMKMapView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        mapView = YMKMapView(frame: bounds, vulkanPreferred: true)
        mapView.mapWindow.map.mapType = .map
    }
}
