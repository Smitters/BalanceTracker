//
//  AddTransactionPresenter.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

protocol AddTransactionResultHandler: AnyObject {
    func handle(result: TransactionResult)
}

final class AddTransactionPresenter {

    unowned let router: BalanceNavigationDelegate
    unowned let resultDelegate: AddTransactionResultHandler
    let balanceService: BalanceService
    
    init(router: BalanceNavigationDelegate, balanceService: BalanceService, resultDelegate: AddTransactionResultHandler) {
        self.router = router
        self.balanceService = balanceService
        self.resultDelegate = resultDelegate
    }
}

extension AddTransactionPresenter: AddTransactionViewController.EventHandler {
    func cellAppearing(at index: Int) -> AddTransactionViewController.CellConfiguration {
        return .init(title: "Test", image: .init(systemName: "add")!)
    }
    
    func handleAddTransaction(with amount: Double, categoryIndex: Int) {
        // try balanceService.subtract(amount, category: expenseCategory)
    }
}
