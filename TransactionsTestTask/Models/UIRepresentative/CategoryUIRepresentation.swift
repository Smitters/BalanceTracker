//
//  CategoryUIRepresentation.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

import UIKit

struct CategoryUIRepresentation {
    let title: String
    let image: UIImage
}

extension CategoryUIRepresentation {
    static func convert(from category: ExpenseCategory) -> CategoryUIRepresentation {
        switch category {
        case .electronics:
            return CategoryUIRepresentation(
                title: String(localized: "electronics"),
                image: UIImage(systemName: "laptopcomputer.and.iphone")!)
        case .entertainment:
            return CategoryUIRepresentation(
                title: String(localized: "entertainment"),
                image: UIImage(systemName: "gamecontroller")!)
        case .groceries:
            return CategoryUIRepresentation(
                title: String(localized: "groceries"),
                image: UIImage(systemName: "cart")!)
        case .restaurant:
            return CategoryUIRepresentation(
                title: String(localized: "restaurant"),
                image: UIImage(systemName: "cup.and.saucer.fill")!)
        case .transport:
            return CategoryUIRepresentation(
                title: String(localized: "transport"),
                image: UIImage(systemName: "car")!)
        case .other:
            return CategoryUIRepresentation(
                title: String(localized: "other"),
                image: UIImage(systemName: "wallet.bifold")!)
        }
    }
}
