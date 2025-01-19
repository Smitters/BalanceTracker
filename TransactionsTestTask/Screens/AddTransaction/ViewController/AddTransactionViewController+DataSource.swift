//
//  AddTransactionViewController+DataSource.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import UIKit

extension AddTransactionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBackground
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .systemGreen
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isHorizontalPreffered = collectionView.bounds.width > collectionView.bounds.height
        let itemsPerRow = isHorizontalPreffered ? 3 : 2
        
        let side = (collectionView.bounds.width - 10 * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow)
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
}

extension AddTransactionViewController {
    struct CellConfiguration {
        let title: String
        let image: UIImage
    }
}
