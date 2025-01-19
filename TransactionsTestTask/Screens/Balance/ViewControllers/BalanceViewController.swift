//
//  BalanceViewController.swift
//  TransactionsTestTask
//
//

import UIKit

class BalanceViewController: UIViewController {
    
    unowned let navigationDelegate: NavigationDelegate
    
    init(navigationDelegate: NavigationDelegate) {
        self.navigationDelegate = navigationDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
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
