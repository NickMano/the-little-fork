//
//  NetworkManager.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import Foundation

final class NetworkManager {
    enum NetworkManagerError: Error {
        case invalidURL
        case managerIsNil
        case nilResponse
        case errorDecodingJson
    }

    private let queue = DispatchQueue(label: "com.nico.mano.TheLittleFork.network-manager", attributes: .concurrent)
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    @available(iOS 15.0, *)
    func sendRequest<D: Decodable>(route: Routable, decodeTo: D.Type) async throws -> D {
        guard var baseURL = URL(string: self.baseURL) else {
            throw NetworkManagerError.invalidURL
        }

        baseURL.appendPathComponent(route.path)

        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw NetworkManagerError.invalidURL
        }

        components.queryItems = route.queryItems

        guard let endpointURL = components.url else {
            throw NetworkManagerError.invalidURL
        }

        var request = URLRequest(url: endpointURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = route.httpMethod.rawValue

        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(D.self, from: data)

        return result
    }

    func sendRequest<D: Decodable>(route: Routable,
                                   decodeTo: D.Type,
                                   completion: @escaping (Result<D, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {
                completion(.failure(NetworkManagerError.managerIsNil))
                return
            }

            guard var baseURL = URL(string: self.baseURL) else {
                completion(.failure(NetworkManagerError.invalidURL))
                return
            }

            baseURL.appendPathComponent(route.path)

            guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
                completion(.failure(NetworkManagerError.invalidURL))
                return
            }

            components.queryItems = route.queryItems

            guard let endpointURL = components.url else {
                completion(.failure(NetworkManagerError.invalidURL))
                return
            }

            var request = URLRequest(url: endpointURL)
            request.httpMethod = route.httpMethod.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            let task = URLSession.shared.dataTask(with: request) {  data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(NetworkManagerError.nilResponse))
                    return
                }

                guard let result = try? JSONDecoder().decode(D.self, from: data) else {
                    completion(.failure(NetworkManagerError.errorDecodingJson))
                    return
                }

                completion(.success(result))
            }

            task.resume()
        }
    }
}
