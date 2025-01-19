//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation

struct Transaction: Codable, Hashable {
    let date: Date
    let amount: Double
    let type: TransactionType
}

enum TransactionType: Codable, Hashable {
    case income
    case expense(ExpenseCategory)
}

enum ExpenseCategory: String, Codable, CaseIterable {
    case groceries
    case transport
    case electronics
    case restaurant
    case entertainment
    case other
}
