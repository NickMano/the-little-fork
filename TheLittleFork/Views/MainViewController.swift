//
//  MainViewController.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    private let mainView = MainView()

    // MARK: - Lifecycle methods
    override func loadView() {
        super.loadView()

        view = mainView
    }
}
