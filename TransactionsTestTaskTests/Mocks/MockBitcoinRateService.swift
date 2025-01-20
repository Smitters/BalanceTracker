//
//  MockBitcoinRateService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

@testable import TransactionsTestTask
import Combine

class MockBitcoinRateService: BitcoinRateService {
    var mockRatePublisher = PassthroughSubject<Rate, Never>()
    var startCalled = false
    
    var ratePublisher: AnyPublisher<Rate, Never> {
        mockRatePublisher.eraseToAnyPublisher()
    }
    
    func start() {
        startCalled = true
    }
    func stop() {}
}
