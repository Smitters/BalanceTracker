//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests
protocol BitcoinRateService: AnyObject {
    var ratePublisher: AnyPublisher<Rate, Never> { get }
    
    func start()
    func stop()
}

final class MobileBitcoinRateService {
        
    private let requestExecutor: RequestExecutor
    private let analytics: AnalyticsService
    private let timer: RepeatableTimer
    private let keyValueStorage: KeyValueStorage
    private let fetchInterval: TimeInterval
    
    private var currentTask: Task<(), Error>?
    
    var rateSubject = CurrentValueSubject<Rate, Never>(.noData)
        
    init(requestExecutor: RequestExecutor,
         analytics: AnalyticsService,
         timer: RepeatableTimer,
         keyValueStorage: KeyValueStorage,
         fetchInterval: TimeInterval = 300
    ) {
        self.requestExecutor = requestExecutor
        self.analytics = analytics
        self.timer = timer
        self.keyValueStorage = keyValueStorage
        self.fetchInterval = fetchInterval
    }
    
    deinit {
        stop()
    }
    
    private func getRate() async throws -> Double {
        do {
            let response: BitcoinPriceResponse = try await requestExecutor.get(url: Constants.rateURL)
            analytics.trackEvent(name: "bitcoin_rate_update", parameters: ["usd_rate": response.bpi.usd.rate])
            return response.bpi.usd.rateFloat
        } catch {
            analytics.trackEvent(name: "bitcoin_rate_failed", parameters: ["error": error.localizedDescription])
            throw error
        }
    }
    
    private func getCachedValue() -> Double? {
        return keyValueStorage.getValue(forKey: Constants.rateCacheKey)
    }
    
    private func updateRateWithCachedValue() {
        guard let cachedValue = keyValueStorage.getValue(forKey: Constants.rateCacheKey) else { return }
        rateSubject.send(.cached(cachedValue))
    }
    
    private func updateRate() {
        currentTask = Task { [weak self] in
            guard let self else { return }
            let rate = try await self.getRate()
            self.keyValueStorage.setValue(rate, forKey: Constants.rateCacheKey)
            self.rateSubject.send(.fetched(rate))
        }
    }
    
    private func scheduleUpdate() {
        timer.schedule(interval: fetchInterval) { [weak self] in
            self?.updateRate()
        }
    }
}

extension MobileBitcoinRateService: BitcoinRateService {
    var ratePublisher: AnyPublisher<Rate, Never> {
        rateSubject.eraseToAnyPublisher()
    }
    
    func start() {
        updateRateWithCachedValue()
        scheduleUpdate()
        updateRate()
    }
    
    func stop() {
        currentTask?.cancel()
        timer.stop()
    }
}

extension MobileBitcoinRateService {
    enum Constants {
        static let rateURL = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        static let rateCacheKey = "bitcoin_rate"
    }
}
