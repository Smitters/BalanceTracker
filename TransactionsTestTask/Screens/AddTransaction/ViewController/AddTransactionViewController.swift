//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import UIKit

final class AddTransactionViewController: UIViewController {
    let eventsHandler: EventHandler
    
    init(viewEventsHandler: EventHandler) {
        self.eventsHandler = viewEventsHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create the UI elements
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = String(localized: "enter.amount")
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .init(resource: .viewBackground)
        collectionView.register(
            ExpenseCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: ExpenseCategoryCollectionViewCell.identifier)
        return collectionView
    }()
    
    private(set) lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String(localized: "confirm"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        view.backgroundColor = UIColor(resource: .viewBackground)
        navigationItem.title = String(localized: "balance.addTransaction")
        setupSubviews()
        setupConstraints()
        
        // Setup Delegates
        collectionView.dataSource = self
        collectionView.delegate = self
        amountTextField.delegate = self
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventsHandler.viewAppeared()
    }
    
    private func setupSubviews() {
        view.addSubview(amountTextField)
        view.addSubview(collectionView)
        view.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Amount TextField constraints
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            amountTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // CollectionView constraints
            collectionView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20),
            
            // Confirm Button constraints
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapConfirmButton() {
        eventsHandler.handleConfirmButtonPressed()
    }
}
