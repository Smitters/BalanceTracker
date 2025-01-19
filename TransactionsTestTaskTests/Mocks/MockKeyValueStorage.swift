//
//  MockKeyValueStorage.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockKeyValueStorage: KeyValueStorage {
    var mockedValue = 0.0
    func getValue(forKey key: String) -> Double? { mockedValue }
    func setValue(_ value: Double, forKey key: String) {}
}
