//
//  MockBalanceService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

@testable import TransactionsTestTask

class MockBalanceService: BalanceService {
    var currentBalance: Double = 0.0
    var topUpResult: TransactionResult = .canceled
    
    func getCurrentBalance() -> Double {
        currentBalance
    }
    
    func add(_ amount: Double) throws -> TransactionResult {
        topUpResult
    }
    
    func subtract(_ amount: Double, category: ExpenseCategory) throws -> TransactionResult {
        topUpResult
    }
}
