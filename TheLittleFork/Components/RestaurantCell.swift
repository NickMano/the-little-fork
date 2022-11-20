//
//  RestaurantCell.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

protocol RestaurantCellDelegate: AnyObject {
    func onLikeButtonTapped(_ uuid: String, hasLiked: Bool)
}

final class RestaurantCell: UITableViewCell {
    // MARK: - Properties
    private let tripLogo = UIImage.tripLogo.withRenderingMode(.alwaysTemplate)
    private var uuid: String = ""

    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()

        view.image = tripLogo
        view.backgroundColor = .secondary
        view.contentMode = .center
        view.tintColor = .accent
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        return view
    }()

    private lazy var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondary
        view.alpha = 0.5

        return view
    }()

    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = .restaurantName
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6

        return label
    }()

    private lazy var address: UILabel = {
        let label = UILabel()
        label.font = .description
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var ratingBadge: Badge = {
        return Badge(.rating)
    }()

    private lazy var offerBadge: Badge = {
        return Badge(.offer)
    }()

    private lazy var hStack: UIStackView = {
        let stack = UIStackView()

        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    private lazy var likeButton: LikeButton = {
        let button = LikeButton(hasLiked: false)
        button.delegate = self

        return button
    }()

    weak var delegate: RestaurantCellDelegate?

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods
    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundImage.image = tripLogo
        backgroundImage.contentMode = .center
        name.text = ""
        address.text = ""
        ratingBadge.setText("")
        likeButton.setIsFavorite(false)

    }
}

// MARK: - Public methods
extension RestaurantCell {
    func setRestaurant(_ restaurant: Restaurant) {
        uuid = restaurant.uuid

        name.text = restaurant.name
        address.text = "\(restaurant.address.street) - \(restaurant.address.locality)"

        let rating = restaurant.aggregateRatings.theFork
        let ratingValue = rating.ratingValue
        ratingBadge.setText("\(ratingValue)")

        if let offer = restaurant.bestOffer?.label {
            setupOfferBadge(offerText: offer)
        } else {
            hStack.removeArrangedSubview(offerBadge)
            offerBadge.isHidden = true
        }
    }

    func setImage(_ image: UIImage?) {
        if let image {
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.image = image
        }
    }

    func setIsFavorite(_ value: Bool) {
        likeButton.setIsFavorite(value)
    }
}

// MARK: - Private methods
private extension RestaurantCell {
    func setupOfferBadge(offerText: String) {
        offerBadge.setText(offerText)
    }
}

// MARK: - ViewCodable
extension RestaurantCell: ViewCodable {
    func buildViewHierarchy() {
        contentView.addSubviews([backgroundImage, likeButton])
        backgroundImage.addSubviews([ blurView, hStack, address])

        [name, ratingBadge, offerBadge].forEach { hStack.addArrangedSubview($0) }
    }

    func setupConstraints() {
        backgroundImage.layout.applyConstraint { view in
            view.heightAnchor(equalToConstant: 180)
            view.topAnchor(equalTo: topAnchor, constant: 20)
            view.bottomAnchor(equalTo: bottomAnchor, constant: -20)
            view.leftAnchor(equalTo: leftAnchor)
            view.rightAnchor(equalTo: rightAnchor)
        }

        likeButton.layout.applyConstraint { view in
            view.rightAnchor(equalTo: rightAnchor, constant: -6)
            view.topAnchor(equalTo: backgroundImage.topAnchor, constant: 6)
        }

        blurView.layout.applyConstraint { view in
            view.topAnchor(equalTo: name.topAnchor, constant: -12)
            view.bottomAnchor(equalTo: backgroundImage.bottomAnchor)
            view.leftAnchor(equalTo: backgroundImage.leftAnchor)
            view.rightAnchor(equalTo: backgroundImage.rightAnchor)
        }

        hStack.layout.applyConstraint { stack in
            stack.leftAnchor(equalTo: leftAnchor, constant: 12)
            stack.rightAnchor(equalTo: rightAnchor, constant: -12)
            stack.bottomAnchor(equalTo: address.topAnchor, constant: -6)
        }

        address.layout.applyConstraint { label in
            label.bottomAnchor(equalTo: backgroundImage.bottomAnchor, constant: -8)
            label.leftAnchor(equalTo: hStack.leftAnchor)
            label.rightAnchor(equalTo: blurView.rightAnchor, constant: -12)
        }
    }

    func configureView() {
        backgroundColor = .clear
    }

    func setupTouchEvents() { }
}

// MARK: - LikeButtonDelegate
extension RestaurantCell: LikeButtonDelegate {
    func onLikeButtonTapped(_ hasLiked: Bool) {
        delegate?.onLikeButtonTapped(uuid, hasLiked: hasLiked)
    }
}
