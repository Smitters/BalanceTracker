//
//  AppCoordinator+BalanceNavigation.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import UIKit

extension AppCoordinator: BalanceViewController.NavigationDelegate {
    func showAddTransactionScreen() {
        let mock = UIViewController()
        mock.view.backgroundColor = .white
        navigationController.pushViewController(mock, animated: true)
    }
}
