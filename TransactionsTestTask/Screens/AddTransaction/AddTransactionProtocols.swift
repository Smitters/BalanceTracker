//
//  AddTransactionProtocols.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

protocol AddTransactionResultHandler: AnyObject {
    func handle(result: TransactionResult)
}

extension AddTransactionViewController {
    protocol EventHandler: AnyObject {
        func viewAppeared()
        func cellTapped(at index: Int)
        func numberOfCells() -> Int
        func cellAppearing(at index: Int) -> CategoryUIRepresentation
        func handleEnteredAmount(_ amount: Double?)
        func handleConfirmButtonPressed()
    }
    
    @MainActor protocol Configurable: AnyObject {
        func setConfirmButtonEnablement(_ isEnabled: Bool)
        func selectCategory(at index: Int)
    }
}
