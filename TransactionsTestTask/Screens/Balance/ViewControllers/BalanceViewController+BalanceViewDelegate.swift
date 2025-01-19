//
//  BalanceViewController+BalanceViewDelegate.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

extension BalanceViewController: BalanceViewDelegate {
    func didTapTopupButton() {
        // Handle top-up logic
        print("Top up button tapped")
    }
    
    func didTapAddTransactionButton() {
        navigationDelegate.showAddTransactionScreen()
    }
}
