//
//  BalanceInteractorTests.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//


import XCTest
import Combine
@testable import TransactionsTestTask

class BalanceInteractorTests: XCTestCase {
    
    var interactor: BalanceInteractor!
    var mockBitcoinService: MockBitcoinRateService!
    var mockBalanceService: MockBalanceService!
    var mockPersistanceManager: MockPersistanceManager!
    var mockOutput: MockBalanceInteractorOutput!
    
    override func setUp() {
        super.setUp()
        mockBitcoinService = MockBitcoinRateService()
        mockBalanceService = MockBalanceService()
        mockPersistanceManager = MockPersistanceManager()
        mockOutput = MockBalanceInteractorOutput()
        
        interactor = BalanceInteractor(bitcoinService: mockBitcoinService,
                                       balanceService: mockBalanceService,
                                       persistanceManager: mockPersistanceManager)
        interactor.output = mockOutput
    }
    
    func testStartRateUpdates() {
        interactor.startRateUpdates()
        XCTAssertEqual(mockBitcoinService.startCalled, true)
        
        let mockRate = Rate.fetched(10000.0)
        mockBitcoinService.mockRatePublisher.send(mockRate)
        XCTAssertEqual(mockOutput.rateReceivedCalled, true)
        XCTAssertEqual(mockOutput.receivedRate, mockRate)
    }
    
    func testGetBalance() {
        mockBalanceService.currentBalance = 500.0
        let balance = interactor.getBalance()
        XCTAssertEqual(balance, 500.0)
    }
    
    func testHandleAddedTransactionIncrementsOffset() {
        interactor.handleAddedTransaction()
        XCTAssertEqual(interactor.offset, 1)
    }
    
    @MainActor func testLoadNextTransactionsSuccess() throws {
        mockPersistanceManager.mockTransactions = []
        let transactions = try interactor.loadNextTransactions()
        XCTAssertEqual(transactions.count, 0)
        XCTAssertEqual(interactor.offset, 0)
        XCTAssertEqual(interactor.hasNextPage, false)
    }
    
    @MainActor func testTopUpBalance() throws {
        let mockDate = Date(timeIntervalSince1970: 0)
        let mockTransactions = Transaction(date: mockDate, amount: 100, type: .income)
        let mockTransactionResult = TransactionResult.completed(mockTransactions, newAmount: 200)
        mockBalanceService.topUpResult = mockTransactionResult
        let result = try interactor.topUpBalance(100.0)
        XCTAssertEqual(result, mockTransactionResult)
    }
}
