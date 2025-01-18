//
//  AnalyticsServiceTests.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 17.01.2025.
//

import XCTest
@testable import TransactionsTestTask

final class AnalyticsServiceTests: XCTestCase {

    private var analyticsService: AnalyticsServiceImpl!
    
    override func setUp() {
        super.setUp()
        analyticsService = AnalyticsServiceImpl()
    }
    
    override func tearDown() {
        analyticsService = nil
        super.tearDown()
    }

    func testTrackEvent_whenEventIsTracked_thenEventIsStored() async {
        // Given
        let eventName = "TestEvent"
        let parameters = ["param1": "value1", "param2": "value2"]
        
        // When
        await analyticsService.trackEvent(name: eventName, parameters: parameters)
        
        // Then
        let events = await analyticsService.getEvents(filters: [])
        XCTAssertEqual(events.count, 1, "Event count should be 1")
        
        guard let event = events.first else {
            XCTFail("No event found")
            return
        }
        
        XCTAssertEqual(event.name, eventName, "Event name should match")
        XCTAssertEqual(event.parameters, parameters, "Event parameters should match")
    }
    
    func testGetEvents_whenNoFiltersApplied_thenAllEventsAreReturned() async {
        // Given
        let eventName1 = "Event1"
        let eventName2 = "Event2"
        let parameters = ["key": "value"]
        
        await analyticsService.trackEvent(name: eventName1, parameters: parameters)
        await analyticsService.trackEvent(name: eventName2, parameters: parameters)
        
        // When
        let events = await analyticsService.getEvents(filters: [])
        
        // Then
        XCTAssertEqual(events.count, 2, "All events should be returned")
        XCTAssertTrue(events.contains { $0.name == eventName1 }, "Event1 should be in the events list")
        XCTAssertTrue(events.contains { $0.name == eventName2 }, "Event2 should be in the events list")
    }
    
    func testGetEvents_whenFilteredByName_thenOnlyMatchingEventsAreReturned() async {
        // Given
        let eventName1 = "Event1"
        let eventName2 = "Event2"
        let parameters = ["key": "value"]
        
        await analyticsService.trackEvent(name: eventName1, parameters: parameters)
        await analyticsService.trackEvent(name: eventName2, parameters: parameters)
        
        // When
        let events = await analyticsService.getEvents(filters: [.byName(eventName1)])
        
        // Then
        XCTAssertEqual(events.count, 1, "Only one event should match the filter")
        XCTAssertEqual(events.first?.name, eventName1, "Filtered event name should match")
    }
    
    func testGetEvents_whenFilteredByDate_thenOnlyMatchingEventsAreReturned() async {
        // Given
        let eventName1 = "Event1"
        let eventName2 = "Event2"
        let parameters = ["key": "value"]
        let date1 = Date(timeIntervalSince1970: 100)
        let date2 = Date(timeIntervalSince1970: 200)
        
        await analyticsService.trackEvent(name: eventName1, parameters: parameters, date: date1)
        await analyticsService.trackEvent(name: eventName2, parameters: parameters, date: date2)
        
        // When
        let events = await analyticsService.getEvents(filters: [
            .byDateInterval(.init(start: date2.addingTimeInterval(-5), end: date2.addingTimeInterval(5)))
        ])
        
        // Then
        XCTAssertEqual(events.count, 1, "Only one event should match the filter")
        XCTAssertEqual(events.first?.name, eventName2, "Filtered event name should match")
    }
}
