//
//  AppCoordinator+BalanceNavigation.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import UIKit

protocol BalanceNavigationDelegate: AnyObject {
    func showAddTransactionScreen(resultDelegate: AddTransactionResultHandler)
}

protocol AddTransactionNavigationDelegate: AnyObject {
    func dismiss()
}

extension AppCoordinator: BalanceNavigationDelegate {
    func showAddTransactionScreen(resultDelegate: AddTransactionResultHandler) {
        let presenter = AddTransactionPresenter(
            router: self,
            balanceService: servicesAssembler.balanceService,
            resultDelegate: resultDelegate)
        let controller = AddTransactionViewController(viewEventsHandler: presenter)
        navigationController.pushViewController(controller, animated: true)
    }
}

extension AppCoordinator: AddTransactionNavigationDelegate {
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
