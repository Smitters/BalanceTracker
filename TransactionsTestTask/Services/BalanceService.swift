//
//  BalanceService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation

protocol BalanceService {
    func getCurrentBalance() -> Double
    
    @MainActor func add(_ amount: Double) throws -> TransactionResult
    @MainActor func subtract(_ amount: Double, category: ExpenseCategory) throws -> TransactionResult
}

final class MobileBalanceService: BalanceService {
    
    private let keyValueStorage: KeyValueStorage
    private let analytics: AnalyticsService
    private let persistenceManager: PersistanceManager
    
    private let balanceQueue = DispatchQueue(label: "MobileBalanceService.syncQueue")
    
    init(persistanceManager: PersistanceManager, keyValueStorage: KeyValueStorage, analytics: AnalyticsService) {
        self.keyValueStorage = keyValueStorage
        self.analytics = analytics
        self.persistenceManager = persistanceManager
    }
    
    func getCurrentBalance() -> Double {
        keyValueStorage.getValue(forKey: Constants.balanceKey) ?? 0
    }
    
    @MainActor func add(_ amount: Double) throws -> TransactionResult {
        do {
            let transaction = Transaction(date: .now, amount: amount, type: .income)
            try persistenceManager.addAndSaveTransaction(transaction)
            var currentBalance = getCurrentBalance()
            currentBalance += amount
            keyValueStorage.setValue(currentBalance, forKey: Constants.balanceKey)
            return .completed(transaction, newAmount: currentBalance)
        } catch {
            analytics.trackEvent(name: "balance.addition_failed", parameters: ["error": error.localizedDescription])
            throw error
        }
    }
    
    @MainActor func subtract(_ amount: Double, category: ExpenseCategory) throws -> TransactionResult {
        do {
            let transaction = Transaction(date: .now, amount: amount, type: .income)
            try persistenceManager.addAndSaveTransaction(transaction)
            
            var currentBalance = getCurrentBalance()
            currentBalance -= amount
            keyValueStorage.setValue(currentBalance, forKey: Constants.balanceKey)
            return .completed(transaction, newAmount: currentBalance)
        } catch {
            analytics.trackEvent(name: "balance.subtraction_failed", parameters: ["error": error.localizedDescription])
            throw error
        }
    }
}

extension MobileBalanceService {
    enum Constants {
        static let balanceKey = "balance"
    }
}
