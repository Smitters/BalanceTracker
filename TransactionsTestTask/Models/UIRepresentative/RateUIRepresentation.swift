//
//  RateUIRepresentation.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

enum RateUIRepresentation {
    case loading
    case loaded(Double)
}

extension RateUIRepresentation {
    static func convert(from rate: Rate) -> Self {
        switch rate {
        case .noData: .loading
        case .cached(let value): .loaded(value)
        case .fetched(let value): .loaded(value)
        }
    }
}
