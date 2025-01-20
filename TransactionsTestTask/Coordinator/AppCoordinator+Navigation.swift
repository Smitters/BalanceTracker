//
//  AppCoordinator+BalanceNavigation.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import UIKit

@MainActor protocol BalanceNavigationDelegate: AnyObject {
    func showAddTransactionScreen(resultDelegate: AddTransactionResultHandler)
}

@MainActor protocol AddTransactionNavigationDelegate: AnyObject {
    func dismiss()
}

extension AppCoordinator: BalanceNavigationDelegate {
    @MainActor func showAddTransactionScreen(resultDelegate: AddTransactionResultHandler) {
        let presenter = AddTransactionPresenter(
            router: self,
            balanceService: servicesAssembler.balanceService,
            resultDelegate: resultDelegate)
        let controller = AddTransactionViewController(viewEventsHandler: presenter)
        presenter.view = controller
        navigationController.pushViewController(controller, animated: true)
    }
}

extension AppCoordinator: AddTransactionNavigationDelegate {
    @MainActor func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
