//
//  BalanceInteractor.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation
import Combine

protocol BalanceInteractorOutput: AnyObject {
    func rateReceived(_ rate: Rate)
}

protocol BalanceInteractorInput: AnyObject {
    func startRateUpdates()
}

class BalanceInteractor {
    let bitcoinService: BitcoinRateService
    weak var output: BalanceInteractorOutput?
    
    var cancellable: AnyCancellable?
    
    init(bitcoinService: BitcoinRateService) {
        self.bitcoinService = bitcoinService
    }
}

extension BalanceInteractor: BalanceInteractorInput {
    func startRateUpdates() {
        cancellable = bitcoinService.ratePublisher.sink { [weak self] rate in
            self?.output?.rateReceived(rate)
        }
        bitcoinService.start()
    }
}
