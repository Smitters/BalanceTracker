//
//  BalanceView.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 18.01.2025.
//

import UIKit

// MARK: - BalanceViewDelegate Protocol
protocol BalanceViewDelegate: AnyObject {
    @MainActor func didTapTopupButton()
    @MainActor func didTapAddTransactionButton()
}

// MARK: - BalanceView
class BalanceView: UIView {
    
    // MARK: - UI Elements
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: String(localized: "balance.amount"), 0)
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: String(localized: "balance.rate"), "...")
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let topupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        return button
    }()
    
    private let addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String(localized: "balance.addTransaction"), for: .normal)
        button.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        return button
    }()
    
    // MARK: - Delegate
    weak var delegate: BalanceViewDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(balanceLabel)
        addSubview(rateLabel)
        addSubview(topupButton)
        addSubview(addTransactionButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        topupButton.translatesAutoresizingMaskIntoConstraints = false
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        
        rateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        balanceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // Constraints for balanceLabel
        let centerXConstraint = balanceLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerXConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            centerXConstraint,
            balanceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: rateLabel.trailingAnchor, constant: 8),
            balanceLabel.trailingAnchor.constraint(lessThanOrEqualTo: topupButton.leadingAnchor, constant: -8)
        ])
        
        // Constraints for rateLabel
        NSLayoutConstraint.activate([
            rateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            rateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            rateLabel.trailingAnchor.constraint(lessThanOrEqualTo: topupButton.leadingAnchor, constant: -8)
        ])
        
        // Constraints for topupButton
        NSLayoutConstraint.activate([
            topupButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor),
            topupButton.leadingAnchor.constraint(equalTo: balanceLabel.trailingAnchor, constant: 8),
            topupButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8)
        ])
        
        // Constraints for addTransactionButton
        NSLayoutConstraint.activate([
            addTransactionButton.topAnchor.constraint(equalTo: topupButton.bottomAnchor, constant: 24),
            addTransactionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addTransactionButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            addTransactionButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8),
            addTransactionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        topupButton.addTarget(self, action: #selector(didTapTopupButton), for: .touchUpInside)
        addTransactionButton.addTarget(self, action: #selector(didTapAddTransactionButton), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    @objc private func didTapTopupButton() {
        delegate?.didTapTopupButton()
    }
    
    @objc private func didTapAddTransactionButton() {
        delegate?.didTapAddTransactionButton()
    }
}

extension BalanceView {
    // MARK: - Public Method to Update Balance and Rates
    func updateBalance(with amount: Double) {
        balanceLabel.text = String(format: String(localized: "balance.amount"), amount)
    }
    
    func setRate(_ rate: Double?) {
        if let rate {
            rateLabel.text = String(format: String(localized: "balance.rate"), "\(rate)")
        } else {
            rateLabel.text = String(format: String(localized: "balance.rate"), "...")
        }
    }
}
