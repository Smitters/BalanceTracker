//
//  MockPersistanceManager.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

@testable import TransactionsTestTask

class MockPersistanceManager: PersistanceManager {
    var mockTransactions: [TransactionDetails] = []
    var addedTransaction: Transaction?
    
    func fetchTransactions(limit: Int, offset: Int) throws -> [TransactionDetails] {
        mockTransactions
    }
    
    func addAndSaveTransaction(_ transaction: Transaction) throws {
        addedTransaction = transaction
    }
}
