//
//  BalanceViewController+TextFieldDelegate.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

import UIKit

extension BalanceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        guard !string.isEmpty else { return true }
        
        let decimalSeparator = Locale.autoupdatingCurrent.decimalSeparator ?? "."
        let regexPattern = "^[0-9]*\(decimalSeparator)?[0-9]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexPattern)
        
        return predicate.evaluate(with: updatedText)
    }
}
