//
//  MainViewError.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 20/11/2022.
//

import UIKit
import SketchKit

final class MainViewError: UIView {
    // MARK: - Properties
    private lazy var message: UILabel = {
       let label = UILabel()
        label.text = "GENERIC_ERROR_MESSAGE".localized
        label.font = .restaurantName
        label.textAlignment = .center

        return label
    }()

    private lazy var retryButton: UIButton = {
       let button = UIButton()
        button.setTitle("RETRY".localized, for: .normal)
        button.titleLabel?.font = .description
        button.backgroundColor = .accent
        button.layer.cornerRadius = 8

        return button
    }()

    var onRetry: (() -> Void)?

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
extension MainViewError: ViewCodable {
    func buildViewHierarchy() {
        addSubviews([message, retryButton])
    }

    func setupConstraints() {
        message.layout.applyConstraint { label in
            label.widthAnchor(equalTo: widthAnchor)
            label.centerYAnchor(equalTo: centerYAnchor, constant: -12)
        }

        retryButton.layout.applyConstraint { button in
            button.centerXAnchor(equalTo: centerXAnchor)
            button.topAnchor(equalTo: message.bottomAnchor, constant: 24)

            button.widthAnchor(equalToConstant: 80)
            button.heightAnchor(equalToConstant: 32)
        }
    }

    func configureView() {
        backgroundColor = .principal
    }

    func setupTouchEvents() {
        retryButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Private methods
private extension MainViewError {
    @objc func onButtonTapped() {
        onRetry?()
    }
}
