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
        guard let newBalance = try? interactor.topUpBalance(amount) else { return }
        view?.update(balance: newBalance)
    }
    
    @MainActor func didTapTopupButton() {
        view?.showTopUpAlert()
    }
    
    @MainActor func didTapAddTransactionButton() {
        router.showAddTransactionScreen()
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
