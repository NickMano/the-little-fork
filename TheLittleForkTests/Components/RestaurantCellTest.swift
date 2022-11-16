//
//  RestaurantCellTest.swift
//  TheLittleForkTests
//
//  Created by nicolas.e.manograsso on 16/11/2022.
//

import XCTest
import SnapshotTesting
import SketchKit
@testable import TheLittleFork

class RestaurantCellTest: XCTestCase {
    private let defaultImage = UIImage(named: "testCellBackground")
    private var sut: RestaurantCell!

    override func setUpWithError() throws {
        sut = RestaurantCell()

        sut.layout.applyConstraint { cell in
            cell.widthAnchor(equalToConstant: 404)
            cell.heightAnchor(equalToConstant: 220)
        }
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCell() {
        sut.setRestaurant(getRestaurant())
        sut.setImage(defaultImage)

        assertSnapshot(matching: sut, as: .image)
    }

    func testCellDarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        sut.setRestaurant(getRestaurant())
        sut.setImage(defaultImage)

        assertSnapshot(matching: sut, as: .image)
    }

    func testCellWithoutBackgroundImage() {
        sut.setRestaurant(getRestaurant())

        assertSnapshot(matching: sut, as: .image)
    }

    func testCellWithoutBackgroundImageDarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        sut.setRestaurant(getRestaurant())

        assertSnapshot(matching: sut, as: .image)
    }

    func testCellWithoutOffer() {
        sut.setRestaurant(getRestaurant(withOffer: false))

        assertSnapshot(matching: sut, as: .image)
    }

    func testCellWithLargeName() {
        sut.setRestaurant(getRestaurant(withLargeName: true))

        assertSnapshot(matching: sut, as: .image)
    }
}

// MARK: - Private methods
private extension RestaurantCellTest {
    func getRestaurant(withLargeName: Bool = false, withOffer: Bool = true) -> Restaurant {
        let name = withLargeName ?
            "Le Beef - The Great and Legendary Steakhouse Viandes Maturées" :
            "Curry Garden"
        let offer = RestaurantOffer(name: "40% off the 'a la carte' menu",
                                    label: "-40%")

        let restaurant = Restaurant(
            name: name,
            uuid: "",
            priceRange: 25,
            address: Address(street: "89 Rue de Bagnolet",
                             postalCode: "75020",
                             locality: "Paris",
                             country: "France"),
            servesCuisine: "Indian",
            aggregateRatings: AggregateRatings(theFork: Rating(ratingValue: 9.7,
                                                               reviewCount: 900),
                                               tripAdvisor: Rating(ratingValue: 8.0,
                                                                   reviewCount: 321)),
            currenciesAccepted: "EUR",
            photo: nil,
            bestOffer: withOffer ? offer : nil)

        return restaurant
    }
}
