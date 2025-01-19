//
//  BalanceService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation

protocol BalanceService {
    func getCurrentBalance() -> Double
    func add(_ amount: Double) -> Double
    func subtract(_ amount: Double) -> Double
}

final class MobileBalanceService: BalanceService {
    
    private let keyValueStorage: KeyValueStorage
    private let analytics: AnalyticsService
    private let balanceQueue = DispatchQueue(label: "MobileBalanceService.syncQueue")
    
    init(keyValueStorage: KeyValueStorage, analytics: AnalyticsService) {
        self.keyValueStorage = keyValueStorage
        self.analytics = analytics
    }
    
    func getCurrentBalance() -> Double {
        balanceQueue.sync {
            keyValueStorage.getValue(forKey: Constants.balanceKey) ?? 0
        }
    }
    
    func add(_ amount: Double) -> Double {
        return balanceQueue.sync {
            var currentBalance = getCurrentBalance()
            currentBalance += amount
            keyValueStorage.setValue(currentBalance, forKey: Constants.balanceKey)
            return currentBalance
        }
    }
    
    func subtract(_ amount: Double) -> Double {
        return balanceQueue.sync {
            var currentBalance = getCurrentBalance()
            currentBalance -= amount
            keyValueStorage.setValue(currentBalance, forKey: Constants.balanceKey)
            return currentBalance
        }
    }
}

extension MobileBalanceService {
    enum Constants {
        static let balanceKey = "balance"
    }
}
