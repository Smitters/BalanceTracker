//
//  Rate.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

enum Rate: Hashable {
    case noData
    case fetched(Double)
    case cached(Double)
}
