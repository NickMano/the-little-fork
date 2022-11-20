//
//  ViewCodable.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

enum ViewState {
    case loading
    case error
    case success
}

protocol ViewCodable {
    /// Method to add the views to the view hierarchy
    func buildViewHierarchy()

    /// Add all the constraints to the views
    func setupConstraints()

    /// Make all the visual configurations on the view
    func configureView()

    /// Adds the touch events to the view
    func setupTouchEvents()
}

extension ViewCodable {
    func setupView() {
        self.buildViewHierarchy()
        self.setupConstraints()
        self.configureView()
        self.setupTouchEvents()
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
