//
//  AppCoordinator+BalanceNavigation.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import UIKit

protocol BalanceNavigationDelegate: AnyObject {
    func showAddTransactionScreen()
}

extension AppCoordinator: BalanceNavigationDelegate {
    func showAddTransactionScreen() {
        let mock = UIViewController()
        mock.view.backgroundColor = .white
        navigationController.pushViewController(mock, animated: true)
    }
}
