//
//  AnalyticsFilters.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import Foundation

enum AnalyticsFilters: Hashable {
    case byName(String)
    case byDateInterval(DateInterval)
    case byParameters([String: String])
}

extension AnalyticsEvent {
    /// Returns true if item passes the filter query
    func filter(using filters: Set<AnalyticsFilters>) -> Bool {
        for filter in filters {
            switch filter {
            case .byName(let filteredName):
                guard name == filteredName else { return false }
            case .byDateInterval(let dateInterval):
                guard dateInterval.contains(date) else { return false }
            case .byParameters(let filteredParameters):
                guard parameters == filteredParameters else { return false }
            }
        }
        return true
    }
}
