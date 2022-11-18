//
//  RestaurantServiceMock.swift
//  TheLittleForkTests
//
//  Created by nicolas.e.manograsso on 17/11/2022.
//

import UIKit
@testable import TheLittleFork

final class RestaurantServiceMock: RestaurantServiceProtocol {
    private let withError: Bool
    private let withPhoto: Bool

    init(withError: Bool = false, withPhoto: Bool = true) {
        self.withError = withError
        self.withPhoto = withPhoto
    }

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
            uuid: "firstRestaurant",
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

}
