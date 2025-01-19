//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation

/// Analytics Service is used for events logging
/// The list of reasonable events is up to you
/// It should be possible not only to track events but to get it from the service
/// The minimal needed filters are: event name and date range
/// The service should be covered by unit tests
protocol AnalyticsService: AnyObject {

    func trackEvent(name: String, parameters: [String: String])
    func getEvents(filters: Set<AnalyticsFilters>) async -> [AnalyticsEvent]
}

public final class AnalyticsServiceImpl {
    
    private let eventSorageActor: EventStorageActor
    
    // MARK: - Init
    
    init() {
        eventSorageActor = EventStorageActor()
    }
    
    func trackEvent(name: String, parameters: [String: String], date: Date = .now) async {
        let event = AnalyticsEvent(
            name: name,
            parameters: parameters,
            date: date
        )
        
        print("\(date) Tracked event: \(name), params: \(parameters)")
        await eventSorageActor.add(event)
    }
}

fileprivate extension AnalyticsServiceImpl {
    
    /// We could track and fetch events from different threads, so we need sync mechanism
    private actor EventStorageActor {
        private var events: [AnalyticsEvent] = []
        
        func add(_ event: AnalyticsEvent) {
            events.append(event)
        }
        
        func getEvents(filters: Set<AnalyticsFilters>) -> [AnalyticsEvent] {
            events.filter { $0.filter(using: filters) }
        }
    }
}

extension AnalyticsServiceImpl: AnalyticsService {
    func getEvents(filters: Set<AnalyticsFilters>) async -> [AnalyticsEvent] {
        await eventSorageActor.getEvents(filters: filters)
    }
    
    func trackEvent(name: String, parameters: [String: String]) {
        Task.detached(priority: .utility) { [weak self] in
            await self?.trackEvent(name: name, parameters: parameters)
        }
    }
}
