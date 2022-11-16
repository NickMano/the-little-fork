//
//  RatingBadge.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

enum BadgeType {
    case rating
    case offer

    var iconImage: UIImage {
        switch self {
        case .rating: return UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        case .offer: return UIImage(systemName: "centsign.circle.fill")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        }
    }
}

final class Badge: UIView {
    // MARK: - Properties
    private let type: BadgeType

    private lazy var iconView: UIImageView = {
        let image = type.iconImage

        let view = UIImageView(image: image)

        view.contentMode = .scaleAspectFit
        view.tintColor = .white

        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .restaurantType
        label.textAlignment = .center
        label.textColor = .white

        return label
    }()

    // MARK: - Initializers
    init(_ type: BadgeType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension Badge {
    func setText(_ text: String) {
        label.text = text
    }
}

// MARK: - ViewCodable
extension Badge: ViewCodable {
    func buildViewHierarchy() {
        addSubviews([iconView, label])
    }

    func setupConstraints() {
        layout.applyConstraint { view in
            view.widthAnchor(greaterThanOrEqualToConstant: type == .offer ? 64 : 50)
        }

        iconView.layout.applyConstraint { view in
            view.widthAnchor(equalToConstant: 20)
            view.heightAnchor(equalToConstant: 20)

            view.topAnchor(equalTo: topAnchor, constant: 4)
            view.bottomAnchor(equalTo: bottomAnchor, constant: -4)
            view.leftAnchor(equalTo: leftAnchor, constant: 4)
        }

        label.layout.applyConstraint { label in
            label.centerYAnchor(equalTo: iconView.centerYAnchor)
            label.leftAnchor(equalTo: iconView.rightAnchor, constant: 4, priority: .dragThatCanResizeScene)
            label.rightAnchor(equalTo: rightAnchor, constant: -4)
        }
    }

    func configureView() {
        backgroundColor = .accent
        layer.cornerRadius = 6
    }

    func setupTouchEvents() {}
}
