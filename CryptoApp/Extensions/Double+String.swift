//
//  Double+Stirng.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation


extension Double {

    private var currencyFormatter2Decimals: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") // <- default value
        formatter.currencyCode = "usd" // <- change currency
        formatter.currencySymbol = "$" // <- change symbol
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }

    /// Converts a Double into a currency with 2 decimal places
    ///```
    /// Convert 123.23 to "$123.23"
    ///```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2Decimals.string(from: number) ?? "$0.00"
    }

    private var currencyFormatter6Decimals: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") // <- default value
        formatter.currencyCode = "usd" // <- change currency
        formatter.currencySymbol = "$" // <- change symbol
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 2
        return formatter
    }

    /// Converts a Double into a currency with 2-6 decimal places
    ///```
    /// Convert 123.23425312312 to "$123.234253"
    /// Convert 123.23 to "$123.23"
    ///```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6Decimals.string(from: number) ?? "$0.00"
    }

    /// Converts a Double into a String representation with two decimals
    ///```
    /// Convert 123.23 to "123.23"
    ///```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }

    /// Converts a Double into a percentage String representation
    ///```
    /// Convert 123.23 to "123.23%"
    ///```
    func asPercentageString() -> String {
        return asNumberString() + "%"
    }

    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formattedNum = num / 1_000_000_000_000
            let stringFormatted = formattedNum.asNumberString()
            return "\(sign)\(stringFormatted) Tr"
        case 1_000_000_000...:
            let formattedNum = num / 1_000_000_000
            let stringFormatted = formattedNum.asNumberString()
            return "\(sign)\(stringFormatted) Bn"
        case 1_000_000...:
            let formattedNum = num / 1_000_000
            let stringFormatted = formattedNum.asNumberString()
            return "\(sign)\(stringFormatted) M"
        case 1_000...:
            let formattedNum = num / 1_000
            let stringFormatted = formattedNum.asNumberString()
            return "\(sign)\(stringFormatted) K"
        case 0...:
            return self.asNumberString()
        default:
            return "\(sign)\(self)"
        }
    }
}
