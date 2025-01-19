//
//  BalanceViewController.NavigationDelegate.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import Foundation

extension BalanceViewController {
    protocol EventHandler: BalanceViewDelegate {
        func handleScreenLoading()
        func handleScreenAppearing()
    }
    
    protocol BalanceViewConfigurable: AnyObject {
        func update(rate: ViewRate)
    }
}

extension BalanceViewController: BalanceViewController.BalanceViewConfigurable {
    func update(rate: ViewRate) {
        switch rate {
        case .loading:
            self.balanceView.setRate(nil)
        case .loaded(let value):
            DispatchQueue.main.async {
                self.balanceView.setRate(value)
            }
        }
    }
}
