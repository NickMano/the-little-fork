//
//  RestaurantService.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

protocol RestaurantServiceProtocol {
    func fetchAll() async throws -> RestaurantResponse
    func fetchRestaurantImage(photo: RestaurantPhoto) async throws -> UIImage
}

enum RestaurantServiceError: Error {
    case noImage
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

    func fetchRestaurantImage(photo: RestaurantPhoto) async throws -> UIImage {
        guard let photoURL = photo.url,
            let url = URL(string: photoURL) else {
            throw NetworkManager.NetworkManagerError.invalidURL
        }

        if #available(iOS 15.0, *) {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else {
                throw RestaurantServiceError.noImage
            }

            return image
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                URLSession.shared.dataTask(with: url) { (data, _, error) in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let data,
                          let image = UIImage(data: data) else {
                        continuation.resume(throwing: RestaurantServiceError.noImage)
                        return
                    }

                    continuation.resume(returning: image)
                }.resume()
            }

        }
    }
}
