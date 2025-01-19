//
//  KeyValueStorage.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import Foundation

protocol KeyValueStorage {
    func setValue(_ value: Double, forKey key: String)
    func getValue(forKey key: String) -> Double?
}

final class UserDefaultsKeyValueStorage: KeyValueStorage {
    private let userDefaultsQueue = DispatchQueue(label: "UserDefaultsKeyValueStorage.syncQueue")
    
    func setValue(_ value: Double, forKey key: String) {
        userDefaultsQueue.sync {
            UserDefaults.standard.setValue(value, forKey: key)
        }
    }
    
    func getValue(forKey key: String) -> Double? {
        return userDefaultsQueue.sync {
            UserDefaults.standard.double(forKey: key)
        }
    }
}
