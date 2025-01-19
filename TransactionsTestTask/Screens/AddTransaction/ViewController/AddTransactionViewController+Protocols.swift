//
//  AddTransactionViewController+Protocols.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

extension AddTransactionViewController {
    protocol EventHandler: AnyObject {
        @MainActor func cellAppearing(at index: Int) -> CellConfiguration
        @MainActor func handleAddTransaction(with amount: Double, categoryIndex: Int)
    }
}
