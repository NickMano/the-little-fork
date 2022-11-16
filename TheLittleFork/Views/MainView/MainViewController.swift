//
//  MainViewController.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    private let mainView: MainViewProtocol
    private let presenter: MainViewPresenterProtocol

    // MARK: - Initializers
    init(view: MainViewProtocol = MainView(),
         presenter: MainViewPresenterProtocol = MainViewPresenter()) {
        self.mainView = view
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)

        mainView.table.dataDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods
    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        callService()
    }
}

// MARK: - Private extension
private extension MainViewController {
    func callService() {
        Task.init {
            do {
                let restaurants = try await presenter.fetchRestaurants()
                mainView.onRestaurantsLoaded(restaurants)
            } catch {
                mainView.onError()
            }
        }
    }
}

extension MainViewController: RestaurantTableDelegate {
    var restaurantsCount: Int {
        presenter.restaurantsCount
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
}
