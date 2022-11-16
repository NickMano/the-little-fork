//
//  MainViewPresenter.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

protocol MainViewPresenterProtocol {
    var restaurantsCount: Int { get }

    func fetchRestaurants() async throws -> [Restaurant]
    func getImageBy(uuid: String) async throws -> UIImage?
    func getRestaurantBy(index: Int) -> Restaurant?
}

final class MainViewPresenter {
    // MARK: - Properties
    private let service: RestaurantServiceProtocol
    private var restaurants: [Restaurant] = []

    // MARK: - Initializers
    init(service: RestaurantServiceProtocol = RestaurantService()) {
        self.service = service
    }
}

// MARK: - MainViewPresenterProtocol
extension MainViewPresenter: MainViewPresenterProtocol {
    var restaurantsCount: Int {
        restaurants.count
    }

    func fetchRestaurants() async throws -> [Restaurant] {
        let response = try await service.fetchAll()
        restaurants = response.data
        return restaurants
    }

    func getImageBy(uuid: String) async throws -> UIImage? {
        guard let restaurant = restaurants.first(where: { $0.uuid == uuid }),
              let photoURL = restaurant.photo?.url,
              let url = URL(string: photoURL) else {
            return nil
        }

        if #available(iOS 15.0, *) {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } else {
            return nil
        }
    }

    func getRestaurantBy(index: Int) -> Restaurant? {
        restaurants.indices.contains(index) ? restaurants[index] : nil
    }
}
