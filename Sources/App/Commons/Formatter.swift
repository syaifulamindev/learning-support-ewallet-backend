//
//  File.swift
//  
//
//  Created by Macbook on 22/08/24.
//

import Foundation

struct Formatter {
  static func toIDR(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "id_ID")
    formatter.maximumFractionDigits = 0 // No decimal places for IDR
    formatter.currencySymbol = "Rp" // Custom symbol if needed

    if let formattedAmount = formatter.string(from: NSNumber(value: amount)) {
        return formattedAmount
    } else {
        return "Rp\(amount)"
    }
}
}
