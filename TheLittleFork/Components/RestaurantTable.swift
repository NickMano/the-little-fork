//
//  RestaurantTable.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

protocol RestaurantTableDelegate: AnyObject {
    var restaurantsCount: Int { get }

    func getRestaurant(for index: Int) -> Restaurant?
    func getImageById(_ uuid: String, completion: @escaping (UIImage?) -> Void)
}

final class RestaurantTable: UITableView {
    // MARK: - Properties
    weak var dataDelegate: RestaurantTableDelegate?

    // MARK: - Initializers
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension RestaurantTable {
    func updateRestaurants(_ restaurants: [Restaurant]) {
        reloadData()
    }
}

// MARK: - UITableViewDataSource
extension RestaurantTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDelegate?.restaurantsCount ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none

        guard let restaurantCell = cell as? RestaurantCell,
              let info = dataDelegate?.getRestaurant(for: indexPath.row)
        else { return cell }

        restaurantCell.setRestaurant(info)

        dataDelegate?.getImageById(info.uuid) { image in
            restaurantCell.setImage(image)
        }

        return restaurantCell
    }
}
