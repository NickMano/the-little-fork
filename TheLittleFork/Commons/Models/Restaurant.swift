//
//  Restaurant.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

struct RestaurantResponse: Codable {
    let data: [Restaurant]
}

struct Restaurant: Codable {
    let name: String
    let uuid: String
    let priceRange: Int // I assume it has no decimals
    let address: Address
    let servesCuisine: String
    let aggregateRatings: AggregateRatings
    let currenciesAccepted: String
    let photo: RestaurantPhoto? // I assume that sometimes it does not have a photo
    let bestOffer: RestaurantOffer? // I assume there is not always an offer

    enum CodingKeys: String, CodingKey {
        case name
        case uuid
        case priceRange
        case address
        case servesCuisine
        case aggregateRatings
        case currenciesAccepted
        case photo = "mainPhoto"
        case bestOffer
    }
}

struct Address: Codable {
    let street: String
    let postalCode: String
    let locality: String
    let country: String
}

struct AggregateRatings: Codable {
    let theFork: Rating
    let tripAdvisor: Rating

    enum CodingKeys: String, CodingKey {
        case theFork = "thefork"
        case tripAdvisor = "tripadvisor"
    }
}

struct Rating: Codable {
    let ratingValue: Float
    let reviewCount: Int
}

struct RestaurantPhoto: Codable {
    let url: String?

    enum CodingKeys: String, CodingKey {
        case url = "664x374"
    }
}

struct RestaurantOffer: Codable {
    let name: String
    let label: String
}
