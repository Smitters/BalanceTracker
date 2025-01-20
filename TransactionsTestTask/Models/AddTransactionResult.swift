//
//  AddTransactionResult.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

enum TransactionResult: Hashable {
    case canceled
    case completed(Transaction, newAmount: Double)
}
