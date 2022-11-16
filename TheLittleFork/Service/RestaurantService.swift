//
//  RestaurantService.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import Foundation

protocol RestaurantServiceProtocol {
    func fetchAll() async throws -> RestaurantResponse
}

struct RestaurantService: RestaurantServiceProtocol {
    // MARK: - Static properties
    static let baseURL = "https://alanflament.github.io"
    static let manager = NetworkManager(baseURL: baseURL)

    // MARK: - Endpoints
    enum Endpoint: Routable {
        case base

        var path: String {
            switch self {
            case .base: return "TFTest/test.json"
            }
        }

        var queryItems: [URLQueryItem]? {
            switch self {
            case .base: return nil
            }
        }

        var httpMethod: HttpMethod {
            switch self {
            case .base: return .get
            }
        }
    }

    func fetchAll() async throws -> RestaurantResponse {
        let manager = RestaurantService.manager

        if #available(iOS 15.0, *) {
            let response = try await manager.sendRequest(route: Endpoint.base, decodeTo: RestaurantResponse.self)
            return response
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                manager.sendRequest(route: Endpoint.base, decodeTo: RestaurantResponse.self) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }
}
