//
//  MockAnalyticsService.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockAnalyticsService: AnalyticsService {
    func getEvents(filters: Set<TransactionsTestTask.AnalyticsFilters>) async -> [TransactionsTestTask.AnalyticsEvent] {
        return []
    }
    
    var events: [(String, [String: String])] = []
    
    func trackEvent(name: String, parameters: [String: String]) {
        events.append((name, parameters))
    }
}
