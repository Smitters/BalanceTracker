//
//  BalanceInteractor.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation
import Combine

protocol BalanceInteractorOutput: AnyObject {
    @MainActor func rateReceived(_ rate: Rate)
}

protocol BalanceInteractorInput: AnyObject {
    func startRateUpdates()
    func getBalance() -> Double
    
    @MainActor func topUpBalance(_ amount: Double) throws -> TransactionResult
    @MainActor func loadNextTransactions() throws -> [Transaction]
}

class BalanceInteractor {
    
    let bitcoinService: BitcoinRateService
    let balanceService: BalanceService
    let persistanceManager: PersistanceManager
    
    weak var output: BalanceInteractorOutput?
    
    var cancellable: AnyCancellable?
    var currentPage: Int = 1
    
    init(bitcoinService: BitcoinRateService, balanceService: BalanceService, persistanceManager: PersistanceManager) {
        self.bitcoinService = bitcoinService
        self.balanceService = balanceService
        self.persistanceManager = persistanceManager
    }
}

extension BalanceInteractor: BalanceInteractorInput {
    func startRateUpdates() {
        cancellable = bitcoinService.ratePublisher.sink { [weak self] rate in
            Task { await self?.output?.rateReceived(rate) }
        }
        bitcoinService.start()
    }
    
    @MainActor func loadNextTransactions() throws -> [Transaction] {
        let offset = Constants.pageSize * (currentPage - 1)
        let transactions = try persistanceManager.fetchTransactions(limit: Constants.pageSize, offset: offset)
        return try transactions.compactMap { details in try Transaction.convert(from: details) }
    }
    
    func getBalance() -> Double {
        balanceService.getCurrentBalance()
    }
    
    @MainActor func topUpBalance(_ amount: Double) throws -> TransactionResult {
        return try balanceService.add(amount)
    }
}

extension BalanceInteractor {
    enum Constants {
        static let pageSize: Int = 20
    }
}
