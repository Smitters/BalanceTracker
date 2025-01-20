//
//  BalanceViewController.swift
//  TransactionsTestTask
//
//

import UIKit

final class BalanceViewController: UIViewController {
    
    let eventsHandler: EventHandler
    
    init(viewEventsHandler: EventHandler) {
        self.eventsHandler = viewEventsHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - BalanceView instance
    lazy var balanceView = BalanceView()
    lazy var transactionsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBalanceView()
        setupTableView()
        eventsHandler.handleScreenLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(resource: .viewBackground)
    }
    
    // MARK: - Setup BalanceView
    private func setupBalanceView() {
        view.addSubview(balanceView)
        balanceView.delegate = eventsHandler
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            balanceView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            balanceView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(transactionsTableView)
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        transactionsTableView.estimatedRowHeight = 82
        transactionsTableView.rowHeight = UITableView.automaticDimension
        transactionsTableView.translatesAutoresizingMaskIntoConstraints = false
        transactionsTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            transactionsTableView.topAnchor.constraint(equalTo: balanceView.bottomAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            transactionsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
