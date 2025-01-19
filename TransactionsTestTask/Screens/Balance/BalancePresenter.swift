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
    func handleScreenLoading() {
        interactor.startRateUpdates()
    }
    
    func didTapTopupButton() {
        
    }
    
    func didTapAddTransactionButton() {
        router.showAddTransactionScreen()
    }
}

extension BalancePresenter: BalanceInteractorOutput {
    func rateReceived(_ rate: Rate) {
        switch rate {
        case .noData: view?.update(rate: .loading)
        case .cached(let value): view?.update(rate: .loaded(value))
        case .fetched(let value): view?.update(rate: .loaded(value))
        }
    }
}
