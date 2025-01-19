//
//  BalanceViewController.NavigationDelegate.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

extension BalanceViewController {
    protocol NavigationDelegate: AnyObject {
        func showAddTransactionScreen()
    }
}
