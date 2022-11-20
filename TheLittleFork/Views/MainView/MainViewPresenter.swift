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
    func getImageBy(uuid: String) async throws -> UIImage
    func getRestaurantBy(index: Int) -> Restaurant?
    func isFavoriteRestaurantBy(uuid: String) -> Bool
    func onFavoriteValueChange(uuid: String, isFavorite: Bool)
}

final class MainViewPresenter {
    // MARK: - Properties
    private let service: RestaurantServiceProtocol
    private var restaurants: [Restaurant] = []

    private var hasFetchedFavoriteRestaurants: Bool = false
    private var favoriteRestaurants: [Restaurant] = []

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

    func getImageBy(uuid: String) async throws -> UIImage {
        guard let restaurant = restaurants.first(where: { $0.uuid == uuid }),
              let photo = restaurant.photo else {
            throw RestaurantServiceError.noImage
        }

        let image = try await service.fetchRestaurantImage(photo: photo)
        return image
    }

    func getRestaurantBy(index: Int) -> Restaurant? {
        restaurants.indices.contains(index) ? restaurants[index] : nil
    }

    func isFavoriteRestaurantBy(uuid: String) -> Bool {
        if !hasFetchedFavoriteRestaurants {
            fetchFavoriteRestaurants()
            hasFetchedFavoriteRestaurants.toggle()
        }

        return favoriteRestaurants.contains { $0.uuid == uuid }
    }

    func onFavoriteValueChange(uuid: String, isFavorite: Bool) {
        guard let restaurant = restaurants.first(where: { $0.uuid == uuid}) else { return }

        if isFavorite {
            service.saveFavorite(uuid)
            favoriteRestaurants.append(restaurant)
        } else {
            service.removeFavorite(uuid)

            guard let indexOfItemToRemove = favoriteRestaurants.firstIndex(of: restaurant) else {
                return
            }

            favoriteRestaurants.remove(at: indexOfItemToRemove)
        }
    }
}

// MARK: - Private methods
private extension MainViewPresenter {
    func fetchFavoriteRestaurants() {
        let uuids = service.getFavorites()
        favoriteRestaurants = uuids.compactMap { uuid in
            restaurants.first { $0.uuid == uuid }
        }
    }
}
