//
//  BalanceViewController+DataSource.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

import UIKit

extension BalanceViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        eventsHandler.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        eventsHandler.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventsHandler.getRowsCount(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier)!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TransactionTableViewCell else { return }
        let configuration = eventsHandler.getCellConfig(row: indexPath.row, section: indexPath.section)
        cell.configure(with: configuration)
        
        if isLastCell(indePath: indexPath) {
            eventsHandler.lastCellReached()
        }
    }
    
    private func isLastCell(indePath: IndexPath) -> Bool {
        guard indePath.section == eventsHandler.sectionsCount - 1 else { return false }
        guard indePath.row == eventsHandler.getRowsCount(in: indePath.section) - 1 else { return false }
        return true
    }
}
