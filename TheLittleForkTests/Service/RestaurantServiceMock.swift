//
//  RestaurantServiceMock.swift
//  TheLittleForkTests
//
//  Created by nicolas.e.manograsso on 17/11/2022.
//

import UIKit
@testable import TheLittleFork

final class RestaurantServiceMock: RestaurantServiceProtocol {
    // MARK: - Properties
    private let withError: Bool
    private let withPhoto: Bool
    private(set) var uuids: [String] = ["1", "2", "3"]

    // MARK: - Initializers
    init(withError: Bool = false, withPhoto: Bool = true) {
        self.withError = withError
        self.withPhoto = withPhoto
    }

    // MARK: - Public methods
    func fetchAll() async throws -> RestaurantResponse {
        if withError {
            throw NetworkManager.NetworkManagerError.invalidURL
        }

        let address = Address(street: "89 Rue de Bagnolet",
                              postalCode: "75020",
                              locality: "Paris",
                              country: "France")

        let rating = Rating(ratingValue: 9.7, reviewCount: 900)
        let aggregateRatings = AggregateRatings(theFork: rating, tripAdvisor: rating)

        let firstRestaurant = Restaurant(
            name: "name",
            uuid: "1",
            priceRange: 25,
            address: address,
            servesCuisine: "Indian",
            aggregateRatings: aggregateRatings,
            currenciesAccepted: "EUR",
            photo: withPhoto ? RestaurantPhoto(url: "") : nil,
            bestOffer: nil)

        let secondRestaurant = Restaurant(
            name: "name",
            uuid: "secondRestaurant",
            priceRange: 25,
            address: address,
            servesCuisine: "Indian",
            aggregateRatings: aggregateRatings,
            currenciesAccepted: "EUR",
            photo: withPhoto ? RestaurantPhoto(url: "") : nil,
            bestOffer: nil)

        let data = RestaurantResponse(data: [firstRestaurant, secondRestaurant])

        return data
    }

    func fetchRestaurantImage(photo: RestaurantPhoto) async throws -> UIImage {
        guard !withError,
              let image = UIImage(named: "testCellBackground") else {
            throw RestaurantServiceError.noImage
        }

        return image
    }

    func getFavorites() -> [String] {
        return uuids
    }

    func saveFavorite(_ uuid: String) {
        uuids.append(uuid)
    }

    func removeFavorite(_ uuid: String) {
        guard let indexOfItemToRemove = uuids.firstIndex(of: uuid) else {
            return
        }

        uuids.remove(at: indexOfItemToRemove)
    }
}
