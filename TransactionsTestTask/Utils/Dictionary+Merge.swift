//
//  Dictionary+Merge.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

extension Dictionary where Key == String, Value: RangeReplaceableCollection {
    mutating func mergeByAppendingElements(_ other: Self) {
        for (key, value) in other {
            if self[key] != nil {
                self[key]?.append(contentsOf: value)
            } else {
                self[key] = value
            }
        }
    }
    
    mutating func mergeByInsertingElements(_ other: Self) {
        for (key, value) in other {
            if self[key] != nil {
                self[key]?.insert(contentsOf: value, at: 0 as! Value.Index)
            } else {
                self[key] = value
            }
        }
    }
}
