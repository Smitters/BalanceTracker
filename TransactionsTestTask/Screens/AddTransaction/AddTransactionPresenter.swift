//
//  AddTransactionPresenter.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import UIKit

final class AddTransactionPresenter {

    unowned private let router: AddTransactionNavigationDelegate
    unowned private let resultDelegate: AddTransactionResultHandler
    private let balanceService: BalanceService
    
    weak var view: AddTransactionViewController.Configurable?
    
    init(router: AddTransactionNavigationDelegate,
         balanceService: BalanceService,
         resultDelegate: AddTransactionResultHandler) {
        self.router = router
        self.balanceService = balanceService
        self.resultDelegate = resultDelegate
    }
    
    private var enteredAmount: Double?
    private  lazy var selectedCategory: Int = categoriesConfiguration.count - 1
    private  lazy var categoriesConfiguration = ExpenseCategory.allCases.compactMap { CategoryUIRepresentation.convert(from: $0) }
}

extension AddTransactionPresenter: AddTransactionViewController.EventHandler {
    func viewAppeared() {
        Task {
            await MainActor.run {
                view?.selectCategory(at: selectedCategory)
                view?.setConfirmButtonEnablement(false)
            }
        }
    }
    
    func cellTapped(at index: Int) {
        selectedCategory = index
    }
    
    func handleEnteredAmount(_ amount: Double?) {
        enteredAmount = amount
        let shouldEnableTransaction = amount != nil
        Task {
            await MainActor.run {
                view?.setConfirmButtonEnablement(shouldEnableTransaction)
            }
        }
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
            let transactionResult = try await balanceService.subtract(amount, category: category)
            resultDelegate.handle(result: transactionResult)
            await MainActor.run {
                router.dismiss()
            }
        }
    }
}
