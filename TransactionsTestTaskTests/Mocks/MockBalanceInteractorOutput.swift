//
//  MockBalanceInteractorOutput.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

@testable import TransactionsTestTask

class MockBalanceInteractorOutput: BalanceInteractorOutput {
    var rateReceivedCalled = false
    var receivedRate: Rate?
    
    func rateReceived(_ rate: Rate) {
        rateReceivedCalled = true
        receivedRate = rate
    }
}
