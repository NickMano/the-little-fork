//
//  MainViewTest.swift
//  TheLittleForkTests
//
//  Created by nicolas.e.manograsso on 20/11/2022.
//

import XCTest
import SnapshotTesting
@testable import TheLittleFork

final class MainViewTest: XCTestCase {
    private let iPhone12ProMaxSize = CGSize(width: 428, height: 926)

    func testLoadingState() {
        let view = MainView(frame: .zero)
        view.overrideUserInterfaceStyle = .light

        assertSnapshot(matching: view, as: .image(size: iPhone12ProMaxSize))
    }

    func testLoadingStateDarkMode() {
        let view = MainView(frame: .zero)
        view.overrideUserInterfaceStyle = .dark

        assertSnapshot(matching: view, as: .image(size: iPhone12ProMaxSize))
    }

    func testSuccessView() {
        let presenter = MainViewPresenterMock()
        let view = MainView(restaurants: getRestaurants(), presenter: presenter)
        view.overrideUserInterfaceStyle = .light

        assertSnapshot(matching: view, as: .image(size: iPhone12ProMaxSize))
    }

    func testSuccessViewDarkMode() {
        let presenter = MainViewPresenterMock()
        let view = MainView(restaurants: getRestaurants(), presenter: presenter)
        view.overrideUserInterfaceStyle = .dark

        assertSnapshot(matching: view, as: .image(size: iPhone12ProMaxSize))
    }

    func testErrorView() {
        let view = MainView(withError: true)
        view.overrideUserInterfaceStyle = .light

        assertSnapshot(matching: view, as: .image(size: iPhone12ProMaxSize))
    }

    func testErrorViewDarkMode() {
        let view = MainView(withError: true)
        view.overrideUserInterfaceStyle = .dark

        assertSnapshot(matching: view, as: .image(size: iPhone12ProMaxSize))
    }
}

private extension MainViewTest {
    func getRestaurants() -> [Restaurant] {
        var restaurants: [Restaurant] = []

        let address = Address(street: "89 Rue de Bagnolet",
                              postalCode: "75020",
                              locality: "Paris",
                              country: "France")

        let rating = Rating(ratingValue: 9.7, reviewCount: 900)
        let aggregateRatings = AggregateRatings(theFork: rating, tripAdvisor: rating)

        for num in 1...10 {
            let restaurant = Restaurant(
                name: "Restaurant \(num)",
                uuid: "1",
                priceRange: 25,
                address: address,
                servesCuisine: "Indian",
                aggregateRatings: aggregateRatings,
                currenciesAccepted: "EUR",
                photo: nil,
                bestOffer: nil)

            restaurants.append(restaurant)
        }

        return restaurants
    }
}
