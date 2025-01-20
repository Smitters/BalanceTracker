//
//  TransactionUIRepresentation.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

import UIKit

struct TransactionUIRepresentation {
    let date: String
    let amount: String
    let categoryName: String
    let amountColor: UIColor
    let categoryImage: UIImage
}

extension TransactionUIRepresentation {
    static func convert(from transaction: Transaction) -> TransactionUIRepresentation {
        let categoryName: String
        let categoryImage: UIImage
        let amountColor: UIColor
        let sign: String
        
        switch transaction.type {
        case .income:
            categoryName = String(localized: "top.up.alert.title")
            categoryImage = UIImage.init(systemName: "bitcoinsign")!
            amountColor = .systemGreen
            sign = "+"
        case .expense(let category):
            let categoryUIRepresentation = CategoryUIRepresentation.convert(from: category)
            categoryName = categoryUIRepresentation.title
            categoryImage = categoryUIRepresentation.image
            amountColor = .systemRed
            sign = "-"
        }
        return .init(
            date: transaction.date.formattedTime,
            amount: sign + transaction.amount.formatted(),
            categoryName: categoryName,
            amountColor: amountColor,
            categoryImage: categoryImage)
    }
}
