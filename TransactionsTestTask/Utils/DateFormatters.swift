//
//  DateFormatters.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 20.01.2025.
//

import Foundation

final class DateFormatters {
    static let dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static let timeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
}

extension Date {
    var formattedDay: String {
        return DateFormatters.dayDateFormatter.string(from: self)
    }
    
    var formattedTime: String {
        return DateFormatters.timeDateFormatter.string(from: self)
    }
}
