//
//  BitcoinPriceResponse.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation

struct BitcoinPriceResponse: Codable {
    let chartName: String
    let bpi: Bpi
        
    struct Bpi: Codable {
        let usd: Currency
        let gbp: Currency
        let eur: Currency
        
        enum CodingKeys: String, CodingKey {
            case usd = "USD"
            case gbp = "GBP"
            case eur = "EUR"
        }
    }
    
    struct Currency: Codable {
        let code: String
        let symbol: String
        let rate: String
        let description: String
        let rateFloat: Double
        
        enum CodingKeys: String, CodingKey {
            case code = "code"
            case symbol = "symbol"
            case rate = "rate"
            case description = "description"
            case rateFloat = "rate_float"
        }
    }
}
