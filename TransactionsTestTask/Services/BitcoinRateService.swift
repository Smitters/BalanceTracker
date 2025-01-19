//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Foundation

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests
protocol BitcoinRateService: AnyObject {
    func start()
    func stop()
    
    func getRate() async throws -> Double
}

final class MobileBitcoinRateService {
        
    private let requestExecutor: RequestExecutor
    private let analytics: AnalyticsService
        
    init(requestExecutor: RequestExecutor, analytics: AnalyticsService) {
        self.requestExecutor = requestExecutor
        self.analytics = analytics
    }
}

extension MobileBitcoinRateService: BitcoinRateService {
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func getRate() async throws -> Double {
        let response: BitcoinPriceResponse = try await requestExecutor.get(url: Constants.rateURL)
        analytics.trackEvent(name: "bitcoin_rate_update", parameters: ["usd_rate": response.bpi.usd.rate])
        return response.bpi.usd.rateFloat
    }
}

extension MobileBitcoinRateService {
    enum Constants {
        static let rateURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
    }
}
