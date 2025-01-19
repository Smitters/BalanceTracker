//
//  BalancePresenter.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

final class BalancePresenter {
    weak var view: BalanceViewController.BalanceViewConfigurable?
    unowned let router: BalanceNavigationDelegate
    let interactor: BalanceInteractorInput
    
    init(router: BalanceNavigationDelegate, interactor: BalanceInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension BalancePresenter: BalanceViewController.EventHandler {
    @MainActor func handleScreenLoading() {
        interactor.startRateUpdates()
        let balance = interactor.getBalance()
        view?.update(balance: balance)
    }
    
    @MainActor func handleTopUp(amount: Double) {
        do {
            let transactionResult = try interactor.topUpBalance(amount)
            
            switch transactionResult {
            case .completed(let transaction, newAmount: let newAmount):
                view?.update(balance: newAmount)
            case .canceled: break
            }
        } catch {
            // TODO: handle error
        }
    }
    
    @MainActor func didTapTopupButton() {
        view?.showTopUpAlert()
    }
    
    @MainActor func didTapAddTransactionButton() {
        router.showAddTransactionScreen(resultDelegate: self)
    }
}

extension BalancePresenter: BalanceInteractorOutput {
    @MainActor func rateReceived(_ rate: Rate) {
        switch rate {
        case .noData: view?.update(rate: .loading)
        case .cached(let value): view?.update(rate: .loaded(value))
        case .fetched(let value): view?.update(rate: .loaded(value))
        }
    }
}

extension BalancePresenter: AddTransactionResultHandler {
    func handle(result: TransactionResult) {
        // TODO: handle
    }
}
