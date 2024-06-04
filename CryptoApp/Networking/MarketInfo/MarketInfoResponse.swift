//
//  MarketInfoResponse.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import Foundation

// MARK: - MarketResponse
struct MarketInfoResponse: Codable {
    let data: MarketData
    let status: Status
}
