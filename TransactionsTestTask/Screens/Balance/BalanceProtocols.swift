//
//  BalanceProtocols.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

protocol BalanceInteractorOutput: AnyObject {
    func rateReceived(_ rate: Rate)
}

protocol BalanceInteractorInput: AnyObject {
    func startRateUpdates()
    func getBalance() -> Double
    func handleAddedTransaction()
    var hasNextPage: Bool { get }
    
    @MainActor func topUpBalance(_ amount: Double) throws -> TransactionResult
    @MainActor func loadNextTransactions() throws -> [Transaction]
}

protocol BalanceViewDelegate: AnyObject {
    func didTapTopupButton()
    func didTapAddTransactionButton()
}

extension BalanceViewController {
    protocol EventHandler: BalanceViewDelegate {
        @MainActor func handleScreenLoading()
        @MainActor func handleTopUp(amount: Double)
        @MainActor func lastCellReached()
        
        var sectionsCount: Int { get }
        var sectionTitles: [String] { get }
        func getRowsCount(in section: Int) -> Int
        func getCellConfig(row: Int, section: Int) -> TransactionUIRepresentation
    }
    
    @MainActor protocol Configurable: AnyObject {
        func update(rate: RateUIRepresentation)
        func update(balance: Double)
        func reloadData()
        func showTopUpAlert()
    }
}
