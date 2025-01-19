//
//  RepeatableTimer.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation

protocol RepeatableTimer {
    var isScheduled: Bool { get }
    func schedule(interval: TimeInterval, action: @escaping () -> Void)
    func stop()
}

final class MobileRepeatableTimer: RepeatableTimer {

    var isScheduled: Bool { repeatTimer != nil }

    func schedule(interval: TimeInterval, action: @escaping () -> Void) {
        stop()
        repeatTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            action()
        }
    }

    func stop() {
        repeatTimer?.invalidate()
        repeatTimer = nil
    }
    
    deinit {
        stop()
    }

    private var repeatTimer: Timer?
}
