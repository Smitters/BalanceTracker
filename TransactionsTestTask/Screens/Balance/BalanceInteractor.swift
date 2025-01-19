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
    
    @MainActor func topUpBalance(_ amount: Double) throws -> Double
}

class BalanceInteractor {
    let bitcoinService: BitcoinRateService
    let balanceService: BalanceService
    
    weak var output: BalanceInteractorOutput?
    
    var cancellable: AnyCancellable?
    
    init(bitcoinService: BitcoinRateService, balanceService: BalanceService) {
        self.bitcoinService = bitcoinService
        self.balanceService = balanceService
    }
}

extension BalanceInteractor: BalanceInteractorInput {
    func startRateUpdates() {
        cancellable = bitcoinService.ratePublisher.sink { [weak self] rate in
            Task {
                await self?.output?.rateReceived(rate)
            }
        }
        bitcoinService.start()
    }
    
    func getBalance() -> Double {
        balanceService.getCurrentBalance()
    }
    
    @MainActor func topUpBalance(_ amount: Double) throws -> Double {
        return try balanceService.add(amount)
    }
}
