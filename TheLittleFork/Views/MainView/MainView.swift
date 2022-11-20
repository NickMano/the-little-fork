//
//  MainView.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit
import SketchKit

protocol MainViewProtocol where Self: UIView {
    var presenter: MainViewPresenterProtocol { get set }
    func onViewDidLoad()
}

final class MainView: UIView {
    // MARK: - Properties
    private lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self

        table.rowHeight = 220

        let identifier = RestaurantCell.identifier
        table.register(RestaurantCell.self, forCellReuseIdentifier: identifier)

        return table
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .large)
        loading.startAnimating()

        return loading
    }()

    private lazy var errorView: MainViewError = {
        return MainViewError()
    }()

    var presenter: MainViewPresenterProtocol = MainViewPresenter()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

    }

    init(withError: Bool = false) {
        super.init(frame: .zero)
        setupView()
        onError()
    }

    init(restaurants: [Restaurant] = [], presenter: MainViewPresenterProtocol) {
        self.presenter = presenter

        super.init(frame: .zero)
        setupView()
        onRestaurantsLoaded(restaurants)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MainViewProtocol
extension MainView: MainViewProtocol {
    func onViewDidLoad() {
        Task.init {
            do {
                let restaurants = try await presenter.fetchRestaurants()
                onRestaurantsLoaded(restaurants)
            } catch {
                onError()
            }
        }
    }
}

// MARK: - Private methods
private extension MainView {
    func onRestaurantsLoaded(_ restaurants: [Restaurant]) {
        setupSuccessView()
        table.reloadData()
    }

    func setupSuccessView() {
        setupViewHierarchyTo(.success)
        setupRestaurantConstraints()
    }

    func setupViewHierarchyTo(_ state: ViewState) {
        subviews.forEach { $0.removeFromSuperview() }

        switch state {
        case .loading:
            addSubview(activityIndicator)
        case .error:
            addSubview(errorView)
        case .success:
            addSubview(table)
        }

    }

    func getRestaurant(for index: Int) -> Restaurant? {
        guard let restaurant = presenter.getRestaurantBy(index: index) else {
            return nil
        }

        return restaurant
    }

    func getImageById(_ uuid: String, completion: @escaping (UIImage?) -> Void) {
        Task.init {
            do {
                let image = try await presenter.getImageBy(uuid: uuid)
                completion(image)
            } catch {
                completion(nil)
            }
        }
    }

    func onError() {
        setupViewHierarchyTo(.error)
        setupErrorViewConstraints()
    }

    func setupLoading() {
        setupViewHierarchyTo(.loading)
        setupLoadingConstraints()
        activityIndicator.startAnimating()
    }

    func setupRestaurantConstraints() {
        table.layout.applyConstraint { table in
            table.topAnchor(equalTo: safeTopAnchor, constant: 10)
            table.leftAnchor(equalTo: leftAnchor, constant: 12)
            table.rightAnchor(equalTo: rightAnchor, constant: -12)
            table.bottomAnchor(equalTo: safeBottomAnchor)
        }
    }

    func setupLoadingConstraints() {
        activityIndicator.layout.applyConstraint { indicator in
            indicator.centerYAnchor(equalTo: centerYAnchor)
            indicator.centerXAnchor(equalTo: centerXAnchor)
        }
    }

    func setupErrorViewConstraints() {
        errorView.layout.applyConstraint { view in
            view.topAnchor(equalTo: safeTopAnchor)
            view.leftAnchor(equalTo: leftAnchor)
            view.rightAnchor(equalTo: rightAnchor)
            view.bottomAnchor(equalTo: safeBottomAnchor)
        }
    }
}

// MARK: - ViewCodable
extension MainView: ViewCodable {
    func buildViewHierarchy() {
        addSubview(activityIndicator)
    }

    func setupConstraints() {
        setupLoadingConstraints()
    }

    func configureView() {
        backgroundColor = .principal
    }

    func setupTouchEvents() {
        errorView.onRetry = {
            self.setupLoading()
            self.onViewDidLoad()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.restaurantsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = RestaurantCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        guard let restaurantCell = cell as? RestaurantCell,
              let info = getRestaurant(for: indexPath.row)
        else { return cell }

        restaurantCell.selectionStyle = .none
        restaurantCell.delegate = self
        restaurantCell.setRestaurant(info)

        getImageById(info.uuid) { image in
            restaurantCell.setImage(image)
        }

        if presenter.isFavoriteRestaurantBy(uuid: info.uuid) {
            restaurantCell.setIsFavorite(true)
        }

        return restaurantCell
    }
}

// MARK: - RestaurantCellDelegate
extension MainView: RestaurantCellDelegate {
    func onLikeButtonTapped(_ uuid: String, hasLiked: Bool) {
        presenter.onFavoriteValueChange(uuid: uuid, isFavorite: hasLiked)
    }
}
