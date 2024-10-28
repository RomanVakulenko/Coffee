//
//  DistanceService.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 20.02.2024.
//

import Foundation
import CoreLocation

// MARK: - DistanceService
protocol DistanceServiceProtocol: AnyObject {
    var locationManager: CLLocationManager { get }
    var cafeUI: [CafeTableModelForUI] { get }
    var locationCompletion: ((CLLocation?) -> Void)? { get }

    func makeUIModelWithDistance(decodedModel: [LocationResponseModel],
                                 locationManager: CLLocationManager,
                                 completion: @escaping ([CafeTableModelForUI]) -> Void)
}

// MARK: - DistanceService
final class DistanceService: NSObject, DistanceServiceProtocol {

    // MARK: - properties
    private(set) var locationManager = CLLocationManager()
    private(set) var cafeUI: [CafeTableModelForUI] = []
    private(set) var locationCompletion: ((CLLocation?) -> Void)?

    // MARK: - Init
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()// For Authorisation from the User.
        self.locationManager.requestWhenInUseAuthorization()// For use in foreground
        self.locationManager.startUpdatingLocation()
    }


    // MARK: - Public methods
    func makeUIModelWithDistance(decodedModel: [LocationResponseModel],
                                 locationManager: CLLocationManager,
                                 completion: @escaping ([CafeTableModelForUI]) -> Void) {
        //в симуляторе важно симулировать метстоположение, иначе будет return
        guard let locationOfUser = locationManager.location else { return }

        for cafe in decodedModel {
            guard let cafeLatitude = Double(cafe.point.latitude),
                  let cafeLongitude = Double(cafe.point.longitude) else { return }
            let locationOfCafe = CLLocation(latitude: cafeLatitude, longitude: cafeLongitude)

            let userLocation = CLLocation(latitude: locationOfUser.coordinate.latitude,
                                          longitude: locationOfUser.coordinate.longitude)
            let distanceInMeters = userLocation.distance(from: locationOfCafe)
            let distanceInKilometers = Int(distanceInMeters / 1000)

            cafeUI.append(CafeTableModelForUI(cafeName: cafe.name,
                                              distanceLabel: "\(distanceInKilometers) км от Вас"))
        }
        print(cafeUI)
        completion(cafeUI)
    }
}

// MARK: - CLLocationManagerDelegate
extension DistanceService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Остановка обновления местоположения чтобы сохраненить заряд батареи
        locationManager.stopUpdatingLocation()

        // Возврат последнего известного местоположения
        if let location = locations.last {
            locationCompletion?(location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Повторный запрос местоположения, если разрешение предоставлено
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            locationCompletion?(nil)
        }
    }
}

