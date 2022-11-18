//
//  MainViewPresenterTest.swift
//  TheLittleForkTests
//
//  Created by nicolas.e.manograsso on 17/11/2022.
//

import XCTest
@testable import TheLittleFork

final class MainViewPresenterTest: XCTestCase {
    // MARK: - fetchRestaurants method
    func testFetchRestaurants() async throws {
        let service = RestaurantServiceMock()
        let sut = MainViewPresenter(service: service)

        let restaurants = try await sut.fetchRestaurants()

        XCTAssertTrue(!restaurants.isEmpty)
    }

    func testFetchRestaurantsError() async throws {
        let service = RestaurantServiceMock(withError: true)
        let sut = MainViewPresenter(service: service)

        do {
            _ = try await sut.fetchRestaurants()
            XCTAssert(false, "The method doesn't catch the error")
        } catch {
            XCTAssert(true, "The method catch the error")
        }
    }

    // MARK: - getImageBy method
    func testGetImageWithoutRestaurants() async throws {
        let service = RestaurantServiceMock()
        let sut = MainViewPresenter(service: service)

        do {
            _ = try await sut.getImageBy(uuid: "")
            XCTAssert(false, "The method doesn't catch the error")
        } catch {
            XCTAssert(true, "The method catch the error")
        }
    }

    func testGetImageWithInvalidId() async throws {
        let service = RestaurantServiceMock()
        let sut = MainViewPresenter(service: service)

        do {
            _ = try await sut.fetchRestaurants()
            _ = try await sut.getImageBy(uuid: "")
            XCTAssert(false, "The method doesn't catch the error")
        } catch {
            XCTAssert(true, "The method catch the error")
        }
    }

    func testGetImageWithoutURL() async throws {
        let service = RestaurantServiceMock(withPhoto: false)
        let sut = MainViewPresenter(service: service)

        do {
            let restaurants = try await sut.fetchRestaurants()
            let uuid = restaurants.first?.uuid

            _ = try await sut.getImageBy(uuid: uuid ?? "")
            XCTAssert(false, "The method doesn't catch the error")
        } catch {
            XCTAssert(true, "The method catch the error")
        }
    }

    func testGetImageById() async throws {
        let service = RestaurantServiceMock()
        let sut = MainViewPresenter(service: service)

        do {
            let restaurants = try await sut.fetchRestaurants()
            let uuid = restaurants.first?.uuid

            _ = try await sut.getImageBy(uuid: uuid ?? "")
            XCTAssert(true, "The method get the image")
        } catch {
            XCTAssert(false, "An unexpected error has occurred")
        }
    }

    // MARK: - getRestaurantBy
    func testGetRestaurantByIndex() async throws {
        let service = RestaurantServiceMock()
        let sut = MainViewPresenter(service: service)

        let restaurants = try await sut.fetchRestaurants()
        let restaunrant = sut.getRestaurantBy(index: 0)

        XCTAssertEqual(restaurants.first, restaunrant)
    }

    func testGetRestaurantByDifferentIndex() async throws {
        let service = RestaurantServiceMock()
        let sut = MainViewPresenter(service: service)

        let restaurants = try await sut.fetchRestaurants()
        let restaunrant = sut.getRestaurantBy(index: 1)

        XCTAssertNotEqual(restaurants.first, restaunrant)
    }

    func testGetRestaurantByInvalidIndex() async throws {
        let service = RestaurantServiceMock()
        let sut = MainViewPresenter(service: service)

        let restaunrant = sut.getRestaurantBy(index: 10)

        XCTAssertNil(restaunrant)
    }
}
