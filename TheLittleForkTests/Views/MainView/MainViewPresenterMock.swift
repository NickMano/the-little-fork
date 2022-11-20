//
//  MainViewPresenterMock.swift
//  TheLittleForkTests
//
//  Created by nicolas.e.manograsso on 20/11/2022.
//

import UIKit
@testable import TheLittleFork

final class MainViewPresenterMock: MainViewPresenterProtocol {
    var restaurantsCount = 10

    func fetchRestaurants() async throws -> [Restaurant] {
        return []
    }

    func getImageBy(uuid: String) async throws -> UIImage {
        return UIImage()
    }

    func getRestaurantBy(index: Int) -> Restaurant? {
        return nil
    }

    func isFavoriteRestaurantBy(uuid: String) -> Bool {
        return false
    }

    func onFavoriteValueChange(uuid: String, isFavorite: Bool) {
    }
}
