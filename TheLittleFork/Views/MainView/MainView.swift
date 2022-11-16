//
//  MainView.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit
import SketchKit

protocol MainViewProtocol where Self: UIView {
    var table: RestaurantTable { get }
    func onRestaurantsLoaded(_ restaurants: [Restaurant])
    func onError()
}

protocol MainViewDelegate: AnyObject {

}

final class MainView: UIView {
    // MARK: - Properties
    lazy var table: RestaurantTable = {
        let table = RestaurantTable()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(RestaurantCell.self, forCellReuseIdentifier: "cell")

        return table
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView: MainViewProtocol {
    func onRestaurantsLoaded(_ restaurants: [Restaurant]) {
        table.updateRestaurants(restaurants)
    }

    func onError() {

    }
}

// MARK: - ViewCodable
extension MainView: ViewCodable {
    func buildViewHierarchy() {
        addSubviews([table])
    }

    func setupConstraints() {
        table.layout.applyConstraint { table in
            table.topAnchor(equalTo: safeTopAnchor, constant: 10)
            table.leftAnchor(equalTo: leftAnchor, constant: 12)
            table.rightAnchor(equalTo: rightAnchor, constant: -12)
            table.bottomAnchor(equalTo: safeBottomAnchor)
        }
    }

    func configureView() {
        backgroundColor = .principal
    }

    func setupTouchEvents() {

    }
}
