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

extension Transaction {
    static func convert(from details: TransactionDetails) throws -> Transaction {
        guard let date = details.date else { throw MappingError.missingDate }
        
        if !details.isTopUp {
            guard let categoryRawValue = details.category,
                  let category = ExpenseCategory(rawValue: categoryRawValue) else {
                throw MappingError.invalidCategory
            }
            
            return Transaction(date: date, amount: details.amount, type: .expense(category))
        } else {
            return Transaction(date: date, amount: details.amount, type: .income)
        }
    }
    
    enum MappingError: Error {
        case invalidCategory
        case missingDate
    }
}
