//
//  YMapViewController.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 22.02.2024.
//

import UIKit
import SnapKit
import YandexMapsMobile

final class YMapViewController: UIViewController, YMapViewable {
    // MARK: - Public properties
    var presenter:YMapPresenterProtocol = YMapPresenter()
    var modelWithCoordinates: [LocationResponseModel] = []

    private lazy var mapView: YMKMapView = YBaseMapView().mapView

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
        modelWithCoordinates = presenter.interactor.modelWithCoordinates
        startMap(cafeLocation: modelWithCoordinates[0])
        addPlacemark(mapView.mapWindow.map, for: modelWithCoordinates)
    }

    // MARK: - Public methods
    func startMap(cafeLocation: LocationResponseModel) {
        let startLocation = YMKPoint(latitude: Double(cafeLocation.point.latitude) ?? 0.0,
                                     longitude: Double(cafeLocation.point.longitude) ?? 0.0)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: startLocation,
                zoom: 9,
                azimuth: 0,
                tilt: 0
            ),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 2),
            cameraCallback: nil)
    }

    // MARK: - Private method
    private func setupView() {
        view.addSubview(mapView)
        view.backgroundColor = .white
        view.addSubview(Show.spinner)
        title = "Карта"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"), //или named: "back24x24" in assets
            style: .plain,
            target: self,
            action: #selector(backAction))
    }

    private func layout() {
        mapView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func addPlacemark(_ map: YMKMap, for cafes: [LocationResponseModel]) {

        for cafe in modelWithCoordinates {
            let image = UIImage(named: "CafePin") ?? UIImage()
            let placemark = map.mapObjects.addPlacemark()
            placemark.geometry = YMKPoint(latitude: Double(cafe.point.latitude) ?? 0.0,
                                          longitude: Double(cafe.point.longitude) ?? 0.0)
            placemark.setIconWith(image)
            placemark.setTextWithText(
                "\(cafe.name)",
                style: YMKTextStyle(
                    size: 14.0,
                    color: Colors.buttonBackgroundColor,
                    outlineColor: .white,
                    placement: .bottom,
                    offset: 0.1,
                    offsetFromIcon: true,
                    textOptional: false
                )
            )
            placemark.userData = cafe.id
            placemark.addTapListener(with: self)
        }
    }

    @objc private func backAction(_ sender: UIButton){
        self.presenter.backButtonDidTap() 
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - YMKMapObjectTapListener
extension YMapViewController: YMKMapObjectTapListener {

    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject,
              let idOfCafe = placemark.userData as? Int else {
            return false
        }
        Show.spinner.startAnimating()
        self.presenter.didTapAtCafe(idOfCafe)
        return true
    }
}
    //    func focusOnPlacemark(_ placemark: YMKPlacemarkMapObject) {
    //        // Поменять расположение камеры, чтобы сфокусироваться на точке
    //        mapView.mapWindow.map.move(
    //            with: YMKCameraPosition(target: placemark.geometry, zoom: 18, azimuth: 0, tilt: 0),
    //            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 1.0),
    //            cameraCallback: nil
    //        )
    //    }
//}


// MARK: - Error Handler
extension YMapViewController: ErrorHandler {}
