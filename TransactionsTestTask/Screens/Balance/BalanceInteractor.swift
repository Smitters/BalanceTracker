//
//  BalanceInteractor.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation
import Combine

class BalanceInteractor {
    
    private let bitcoinService: BitcoinRateService
    private let balanceService: BalanceService
    private let persistanceManager: PersistanceManager
    
    weak var output: BalanceInteractorOutput?
    
    private var cancellable: AnyCancellable?
    private var offset: Int = 0
    private(set) var hasNextPage: Bool = true
    
    init(bitcoinService: BitcoinRateService, balanceService: BalanceService, persistanceManager: PersistanceManager) {
        self.bitcoinService = bitcoinService
        self.balanceService = balanceService
        self.persistanceManager = persistanceManager
    }
}

extension BalanceInteractor: BalanceInteractorInput {
    func startRateUpdates() {
        cancellable = bitcoinService.ratePublisher.sink { [weak self] rate in
            self?.output?.rateReceived(rate)
        }
        bitcoinService.start()
    }
    
    func getBalance() -> Double {
        balanceService.getCurrentBalance()
    }
    
    func handleAddedTransaction() {
        offset += 1
    }
    
    @MainActor func loadNextTransactions() throws -> [Transaction] {
        do {
            let transactions = try persistanceManager.fetchTransactions(limit: Constants.pageSize, offset: offset)
            let mappedTransactions = try transactions.compactMap { details in try Transaction.convert(from: details) }
            
            if mappedTransactions.count < Constants.pageSize {
                hasNextPage = false
                offset = mappedTransactions.count
            } else {
                offset += Constants.pageSize
                hasNextPage = true
            }
            
            return mappedTransactions
        } catch {
            if let error = error as? FetchError, error == .noMoreItems {
                hasNextPage = false
                return []
            } else {
                throw error
            }
        }
    }
    
    @MainActor func topUpBalance(_ amount: Double) throws -> TransactionResult {
        try balanceService.add(amount)
    }
}

extension BalanceInteractor {
    enum Constants {
        static let pageSize: Int = 20
    }
}
