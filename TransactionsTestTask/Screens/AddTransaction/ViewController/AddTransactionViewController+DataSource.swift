//
//  AddTransactionViewController+DataSource.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import UIKit

extension AddTransactionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        eventsHandler.numberOfCells()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ExpenseCategoryCollectionViewCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let expenseCell = cell as? ExpenseCategoryCollectionViewCell else { return }
        let config = eventsHandler.cellAppearing(at: indexPath.item)
        expenseCell.configure(with: config.image, title: config.title)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isHorizontalPreffered = collectionView.bounds.width > collectionView.bounds.height
        let itemsPerRow = isHorizontalPreffered ? 3 : 2
        
        let side = (collectionView.bounds.width - 10 * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow)
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        eventsHandler.cellTapped(at: indexPath.item)
    }
}

extension AddTransactionViewController {
    struct CellConfiguration {
        let title: String
        let image: UIImage
    }
}
