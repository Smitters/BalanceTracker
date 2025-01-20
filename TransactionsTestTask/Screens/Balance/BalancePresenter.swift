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
    
    private var groupedTransactions: [String: [Transaction]] = [:]
    private var sortedKeys: [String] = []
    
    init(router: BalanceNavigationDelegate, interactor: BalanceInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension BalancePresenter: BalanceViewController.EventHandler {
    func handleScreenLoading() {
        interactor.startRateUpdates()
        let balance = interactor.getBalance()
        view?.update(balance: balance)
        
        do {
            let transactions = try interactor.loadNextTransactions()
            let grouped = Dictionary(grouping: transactions) { $0.date.formattedDay }
            groupedTransactions.mergeByAppendingElements(grouped)
            sortedKeys = groupedTransactions.keys.sorted()
            view?.reloadData()
        } catch {
            print(error)
        }
    }
    
    func handleTopUp(amount: Double) {
        do {
            let transactionResult = try interactor.topUpBalance(amount)
            handle(result: transactionResult)
        } catch {
            // TODO: handle error
        }
    }
    
    func didTapTopupButton() {
        view?.showTopUpAlert()
    }
    
    func didTapAddTransactionButton() {
        router.showAddTransactionScreen(resultDelegate: self)
    }
    
    var sectionsCount: Int {
        sortedKeys.count
    }
    
    var sectionTitles: [String] {
        sortedKeys
    }
    
    func getRowsCount(in section: Int) -> Int {
        let key = sortedKeys[section]
        return groupedTransactions[key]?.count ?? 0
    }
    
    func getCellConfig(row: Int, section: Int) -> TransactionUIRepresentation {
        let key = sortedKeys[section]
        let transactions = groupedTransactions[key] ?? []
        return TransactionUIRepresentation.convert(from: transactions[row])
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

extension BalancePresenter: AddTransactionResultHandler {
    func handle(result: TransactionResult) {
        switch result {
        case .completed(let transaction, newAmount: let newAmount):
            view?.update(balance: newAmount)
            let key = transaction.date.formattedDay
            groupedTransactions.mergeByAppendingElements([key: [transaction]])
            sortedKeys = groupedTransactions.keys.sorted()
        case .canceled: break
        }
    }
}
