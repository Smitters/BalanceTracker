//
//  AddTransactionPresenter.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

protocol AddTransactionResultHandler: AnyObject {
    @MainActor func handle(result: TransactionResult)
}

import UIKit

final class AddTransactionPresenter {

    unowned let router: AddTransactionNavigationDelegate
    unowned let resultDelegate: AddTransactionResultHandler
    let balanceService: BalanceService
    
    weak var view: AddTransactionViewController.ViewConfigurable?
    
    init(router: AddTransactionNavigationDelegate,
         balanceService: BalanceService,
         resultDelegate: AddTransactionResultHandler) {
        self.router = router
        self.balanceService = balanceService
        self.resultDelegate = resultDelegate
    }
    
    var enteredAmount: Double?
    lazy var selectedCategory: Int = categoriesConfiguration.count - 1
    lazy var categoriesConfiguration = ExpenseCategory.allCases.compactMap { CategoryUIRepresentation.convert(from: $0) }
}

extension AddTransactionPresenter: AddTransactionViewController.EventHandler {
    func viewAppeared() {
        view?.selectCategory(at: selectedCategory)
        view?.setConfirmButtonEnablement(false)
    }
    
    func cellTapped(at index: Int) {
        selectedCategory = index
    }
    
    func handleEnteredAmount(_ amount: Double?) {
        enteredAmount = amount
        let shouldEnableTransaction = amount != nil
        view?.setConfirmButtonEnablement(shouldEnableTransaction)
    }
    
    func numberOfCells() -> Int {
        categoriesConfiguration.count
    }
    
    func cellAppearing(at index: Int) -> CategoryUIRepresentation {
        return categoriesConfiguration[index]
    }
    
    func handleConfirmButtonPressed() {
        guard let amount = enteredAmount else { return }
        let category = ExpenseCategory.allCases[selectedCategory]
        Task {
            let transactionResult = try balanceService.subtract(amount, category: category)
            resultDelegate.handle(result: transactionResult)
            router.dismiss()
        }
    }
}
