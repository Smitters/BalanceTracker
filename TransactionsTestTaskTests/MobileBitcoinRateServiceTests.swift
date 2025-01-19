//
//  MobileBitcoinRateServiceTests.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import XCTest
import Combine
@testable import TransactionsTestTask

final class MobileBitcoinRateServiceTests: XCTestCase {
    
    var service: MobileBitcoinRateService!
    var requestExecutor: MockRequestExecutor!
    var analytics: MockAnalyticsService!
    var timer: MockRepeatableTimer!
    var keyValueStorage: MockKeyValueStorage!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        requestExecutor = MockRequestExecutor()
        analytics = MockAnalyticsService()
        timer = MockRepeatableTimer()
        keyValueStorage = MockKeyValueStorage()
        service = MobileBitcoinRateService(
            requestExecutor: requestExecutor,
            analytics: analytics,
            timer: timer,
            keyValueStorage: keyValueStorage,
            fetchInterval: 300
        )
        cancellables = []
    }
    
    override func tearDown() {
        service = nil
        requestExecutor = nil
        analytics = nil
        timer = nil
        keyValueStorage = nil
        cancellables = []
        super.tearDown()
    }
    
    func testUpdateRateWithSuccess() throws {
        // Given
        let mockCurrency: BitcoinPriceResponse.Currency = .init(code: "USD", symbol: "$", rate: "100", description: "", rateFloat: 100)
        let mockBpi = BitcoinPriceResponse.Bpi(usd: mockCurrency, gbp: mockCurrency, eur: mockCurrency)
        let mockRate = BitcoinPriceResponse(chartName: "mock", bpi: mockBpi)
        requestExecutor.mockedResult = .success(mockRate)
        
        // When
        service.start()
        timer.trigger() // Simulate timer triggering
        
        // Then
        let expectation = XCTestExpectation(description: "Fetch rate")
        service.ratePublisher.sink { rate in
            switch rate {
            case .fetched(let value):
                XCTAssertEqual(value, 100)
                expectation.fulfill()
            default:
                break
            }
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(analytics.events.contains { $0.0 == "bitcoin_rate_update" })
    }
    
    func testUpdateRateWithFailureReturnsCached() throws {
        // Given
        requestExecutor.mockedResult = .failure(URLError(.notConnectedToInternet))
        keyValueStorage.mockedValue = 32000
        
        // When
        service.start()
        timer.trigger() // Simulate timer triggering
        
        // Then
        let expectation = XCTestExpectation(description: "Fetch rate failed")
        service.ratePublisher.sink { rate in
            switch rate {
            case .cached(let value):
                XCTAssertEqual(32000, value)
                expectation.fulfill()
            default:
                break
            }
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUsesCachedValue() {
        // Given
        keyValueStorage.mockedValue = 32000
        
        // When
        service.start()
        
        // Then
        let expectation = XCTestExpectation(description: "Cached rate used")
        service.ratePublisher.sink { rate in
            switch rate {
            case .cached(let value):
                XCTAssertEqual(value, 32000)
                expectation.fulfill()
            default:
                XCTFail("Expected cached rate")
            }
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testStopService() {
        // When
        service.start()
        service.stop()
        
        // Then
        XCTAssertNil(timer.action)
    }
}
