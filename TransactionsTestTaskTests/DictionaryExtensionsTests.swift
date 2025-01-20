//
//  DictionaryExtensionsTests.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//


import XCTest
@testable import TransactionsTestTask

final class DictionaryExtensionsTests: XCTestCase {

    // MARK: - Tests for mergeByAppendingElements
    
    func testMergeByAppendingElements_EmptyDictionary() {
        var dict1: [String: [Int]] = [:]
        let dict2: [String: [Int]] = ["key1": [1, 2, 3]]

        dict1.mergeByAppendingElements(dict2)

        XCTAssertEqual(dict1, ["key1": [1, 2, 3]])
    }

    func testMergeByAppendingElements_NonOverlappingKeys() {
        var dict1: [String: [Int]] = ["key1": [1, 2, 3]]
        let dict2: [String: [Int]] = ["key2": [4, 5, 6]]

        dict1.mergeByAppendingElements(dict2)

        XCTAssertEqual(dict1, ["key1": [1, 2, 3], "key2": [4, 5, 6]])
    }

    func testMergeByAppendingElements_OverlappingKeys() {
        var dict1: [String: [Int]] = ["key1": [1, 2, 3]]
        let dict2: [String: [Int]] = ["key1": [4, 5, 6]]

        dict1.mergeByAppendingElements(dict2)

        XCTAssertEqual(dict1, ["key1": [1, 2, 3, 4, 5, 6]])
    }

    // MARK: - Tests for mergeByInsertingElements

    func testMergeByInsertingElements_EmptyDictionary() {
        var dict1: [String: [Int]] = [:]
        let dict2: [String: [Int]] = ["key1": [1, 2, 3]]

        dict1.mergeByInsertingElements(dict2)

        XCTAssertEqual(dict1, ["key1": [1, 2, 3]])
    }

    func testMergeByInsertingElements_NonOverlappingKeys() {
        var dict1: [String: [Int]] = ["key1": [1, 2, 3]]
        let dict2: [String: [Int]] = ["key2": [4, 5, 6]]

        dict1.mergeByInsertingElements(dict2)

        XCTAssertEqual(dict1, ["key1": [1, 2, 3], "key2": [4, 5, 6]])
    }

    func testMergeByInsertingElements_OverlappingKeys() {
        var dict1: [String: [Int]] = ["key1": [4, 5, 6]]
        let dict2: [String: [Int]] = ["key1": [1, 2, 3]]

        dict1.mergeByInsertingElements(dict2)

        XCTAssertEqual(dict1, ["key1": [1, 2, 3, 4, 5, 6]])
    }
}
