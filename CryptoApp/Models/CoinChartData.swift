//
//  CoinChartData.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 13/6/24.
//

import Foundation


struct CoinChartData: Identifiable {
    let id: UUID
    let daysAgo: Int
    let value: Double
}
