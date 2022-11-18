//
//  MainViewController.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Properties
    private let mainView: MainViewProtocol

    // MARK: - Initializers
    init(view: MainViewProtocol = MainView(),
         presenter: MainViewPresenterProtocol = MainViewPresenter()) {
        mainView = view
        mainView.presenter = presenter

        super.init(nibName: nil, bundle: nil)
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
        mainView.onViewDidLoad()
    }
}
