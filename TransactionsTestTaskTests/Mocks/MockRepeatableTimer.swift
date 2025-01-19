//
//  MockRepeatableTimer.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockRepeatableTimer: RepeatableTimer {
    var isScheduled: Bool = false
    
    var interval: TimeInterval?
    var action: (() -> Void)?
    
    func schedule(interval: TimeInterval, action: @escaping () -> Void) {
        self.interval = interval
        self.action = action
        isScheduled = true
    }
    
    func stop() {
        action = nil
        isScheduled = false
    }
    
    func trigger() {
        action?()
    }
}
