//
//  MainView.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit
import SketchKit

final class MainView: UIView {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCodable
extension MainView: ViewCodable {
    func buildViewHierarchy() {

    }

    func setupConstraints() {

    }

    func configureView() {
        backgroundColor = .red
    }

    func setupTouchEvents() {

    }
}
