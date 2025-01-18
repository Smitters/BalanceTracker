//
//  BalanceViewController.swift
//  TransactionsTestTask
//
//

import UIKit

class BalanceViewController: UIViewController {
    
    // MARK: - BalanceView instance
    private let balanceView = BalanceView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBalanceView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    // MARK: - Setup BalanceView
    private func setupBalanceView() {
        view.addSubview(balanceView)
        balanceView.delegate = self
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
