//
//  MenuService.swift
//  CoffeeByVakulenko
//
//  Created by Roman Vakulenko on 14.02.2024.
//


import UIKit
import Alamofire

protocol MenuServiceProtocol: AnyObject {
    func makeCoffeeModelWithFoto(for models: [MenuModel],
                                 completion: @escaping (Result<[OrderModel], Error>) -> Void)
    func refreshStorage()
}

final class MenuService: MenuServiceProtocol {
    private var coffeeModelsWithPhoto: [OrderModel] = []
    private var fileManager = FileManager.default
    /// С помощью DispatchGroup азагружаются картинки, как все загрузились - передаем в комплишене их
    func makeCoffeeModelWithFoto(for models: [MenuModel],
                                 completion: @escaping (Result<[OrderModel], Error>) -> Void) {
        let group = DispatchGroup()

        for menu in models {
            group.enter()
            AF.download(menu.imageURL).responseData { response in
                defer { group.leave() }

                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        if let imageData = image.pngData() {
                            let documentDir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let url = URL(string: menu.imageURL)
                            let imageName = url?.lastPathComponent ?? "\(menu.name.replacingOccurrences(of: " ", with: "_"))"
                            let fileName = "\(menu.id)_\(imageName)"
                            let fileURL = documentDir.appendingPathComponent(fileName)

                            do {
                                try imageData.write(to: fileURL)
                                self.coffeeModelsWithPhoto.append(
                                    OrderModel(id: menu.id,
                                               coffeeName: menu.name,
                                               imageURL: fileURL.path,
                                               quantity: 0,
                                               price: menu.price))
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        group.notify(queue: .main) {
            completion(.success(self.coffeeModelsWithPhoto))
        }
    }

    func refreshStorage() {
        do {
            let documentDir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURLs = try self.fileManager.contentsOfDirectory(at: documentDir, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Ошибка при очистке директории: \(error)")
        }
    }
}


