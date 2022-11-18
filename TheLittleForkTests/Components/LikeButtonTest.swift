//
//  LikeButtonTest.swift
//  TheLittleForkTests
//
//  Created by nicolas.e.manograsso on 18/11/2022.
//

import XCTest
import SnapshotTesting
@testable import TheLittleFork

final class LikeButtonTest: XCTestCase {
    func testUnlike() {
        let sut = LikeButton(hasLiked: false)

        assertSnapshot(matching: sut, as: .image)
    }

    func testLike() {
        let sut = LikeButton(hasLiked: true)

        assertSnapshot(matching: sut, as: .image)
    }
}
