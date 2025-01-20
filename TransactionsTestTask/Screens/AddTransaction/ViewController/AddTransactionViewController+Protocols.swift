//
//  AddTransactionViewController+Protocols.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import UIKit

extension AddTransactionViewController {
    protocol EventHandler: AnyObject {
        @MainActor func viewAppeared()
        @MainActor func cellTapped(at index: Int)
        @MainActor func numberOfCells() -> Int
        @MainActor func cellAppearing(at index: Int) -> CategoryUIRepresentation
        @MainActor func handleEnteredAmount(_ amount: Double?)
        @MainActor func handleConfirmButtonPressed()
    }
    
    protocol ViewConfigurable: AnyObject {
        @MainActor func setConfirmButtonEnablement(_ isEnabled: Bool)
        @MainActor func selectCategory(at index: Int)
    }
}

extension AddTransactionViewController: AddTransactionViewController.ViewConfigurable {
    func setConfirmButtonEnablement(_ isEnabled: Bool) {
        confirmButton.isEnabled = isEnabled
    }
    
    func selectCategory(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}
