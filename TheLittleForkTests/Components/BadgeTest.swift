//
//  BadgeTest.swift
//  TheLittleForkTests
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import XCTest
import SnapshotTesting
@testable import TheLittleFork

final class BadgeTest: XCTestCase {
    func testEmptyRatingBadge() throws {
        let badge = Badge(.rating)
        let viewController = UIViewController()
        viewController.view.addSubview(badge)

        badge.layout.applyConstraint { badge in
            badge.topAnchor(equalTo: viewController.view.topAnchor)
            badge.leftAnchor(equalTo: viewController.view.leftAnchor)
        }

        assertSnapshot(matching: viewController, as: .image())
    }

    func testEmptyOfferBadge() throws {
        let badge = Badge(.offer)
        let viewController = UIViewController()
        viewController.view.addSubview(badge)

        badge.layout.applyConstraint { badge in
            badge.topAnchor(equalTo: viewController.view.topAnchor)
            badge.leftAnchor(equalTo: viewController.view.leftAnchor)
        }

        assertSnapshot(matching: viewController, as: .image())
    }

    func testRatingBadge() throws {
        let badge = Badge(.rating)
        badge.setText("9.4")

        let viewController = UIViewController()
        viewController.view.addSubview(badge)

        badge.layout.applyConstraint { badge in
            badge.topAnchor(equalTo: viewController.view.topAnchor)
            badge.leftAnchor(equalTo: viewController.view.leftAnchor)
        }

        assertSnapshot(matching: viewController, as: .image())
    }

    func testOfferBadge() throws {
        let badge = Badge(.offer)
        badge.setText("-40%")

        let viewController = UIViewController()
        viewController.view.addSubview(badge)

        badge.layout.applyConstraint { badge in
            badge.topAnchor(equalTo: viewController.view.topAnchor)
            badge.leftAnchor(equalTo: viewController.view.leftAnchor)
        }

        assertSnapshot(matching: viewController, as: .image())
    }
}
