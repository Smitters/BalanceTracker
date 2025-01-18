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
        // Handle add transaction logic
        print("Add transaction button tapped")
    }
}
