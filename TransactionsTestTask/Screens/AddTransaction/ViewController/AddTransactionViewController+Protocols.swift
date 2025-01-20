//
//  AddTransactionViewController+Protocols.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import UIKit

extension AddTransactionViewController: AddTransactionViewController.Configurable {
    func setConfirmButtonEnablement(_ isEnabled: Bool) {
        confirmButton.isEnabled = isEnabled
    }
    
    func selectCategory(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}
