//
//  BalanceViewController.Configurable.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import Foundation
import UIKit

extension BalanceViewController: BalanceViewController.Configurable {
    func update(rate: RateUIRepresentation) {
        switch rate {
        case .loading:
            self.balanceView.setRate(nil)
        case .loaded(let value):
            self.balanceView.setRate(value)
        }
    }
    
    func update(balance: Double) {
        balanceView.updateBalance(with: balance)
    }
    
    func reloadData() {
        transactionsTableView.reloadData()
    }
    
    func showTopUpAlert() {
        let alert = UIAlertController(
            title: String(localized: "top.up.alert.title"),
            message: String(localized: "top.up.alert.message"),
            preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = String(localized: "amount")
            textField.keyboardType = .decimalPad
        }
        alert.addAction(UIAlertAction(title: String(localized: "confirm"), style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, let amount = Double(text) else { return }
            self?.eventsHandler.handleTopUp(amount: amount)
        })
        alert.addAction(UIAlertAction(title: String(localized: "cancel"), style: .cancel))
        present(alert, animated: true)
    }
}
