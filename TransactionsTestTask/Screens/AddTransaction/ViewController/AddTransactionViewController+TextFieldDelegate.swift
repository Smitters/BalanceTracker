//
//  AddTransactionViewController+TextFieldDelegate.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

import UIKit

extension AddTransactionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if string.isEmpty {
            eventsHandler.handleEnteredAmount(nil)
            return true
        }
        
        let decimalSeparator = Locale.autoupdatingCurrent.decimalSeparator ?? "."
        let regexPattern = "^[0-9]*\(decimalSeparator)?[0-9]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexPattern)
        
        let shouldChange = predicate.evaluate(with: updatedText)
     
        if shouldChange {
            let amount = NumberFormatter().number(from: updatedText)?.doubleValue
            eventsHandler.handleEnteredAmount(amount)
        }
        return shouldChange
    }
}
