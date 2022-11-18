//
//  LikeButton.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 18/11/2022.
//

import UIKit
import SketchKit

final class LikeButton: UIView {
    private(set) var hasLiked: Bool
    private var likeImage: UIImage {
        hasLiked ? UIImage.heartFull : UIImage.heartEmpty
    }

    private lazy var likeButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 20
        button.setImage(likeImage, for: .normal)

        return button
    }()

    // MARK: - Initializers
    init(hasLiked: Bool) {
        self.hasLiked = hasLiked
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCodable
extension LikeButton: ViewCodable {
    func buildViewHierarchy() {
        addSubview(likeButton)
    }

    func setupConstraints() {
        layout.applyConstraint { view in
            view.widthAnchor(equalToConstant: 40)
            view.heightAnchor(equalToConstant: 40)
        }

        likeButton.layout.applyConstraint { button in
            button.topAnchor(equalTo: topAnchor)
            button.bottomAnchor(equalTo: bottomAnchor)
            button.leftAnchor(equalTo: leftAnchor)
            button.rightAnchor(equalTo: rightAnchor)
        }
    }

    func configureView() {
        backgroundColor = .clear
    }

    func setupTouchEvents() {
        likeButton.addTarget(self, action: #selector(onTaped), for: .touchUpInside)
    }
}

extension LikeButton {
    @objc func onTaped() {
        hasLiked.toggle()
        likeButton.setImage(likeImage, for: .normal)
    }
}
