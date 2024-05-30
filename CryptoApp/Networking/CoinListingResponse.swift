//
//  CoinListingResponse.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation

struct CoinListingResponse: Codable {
    let status: Status
    let data: [Coin]
}

struct Status: Codable {
    let timestamp: String
    let errorCode: Int
    let errorMessage: String?
    let elapsed: Int
    let creditCount: Int
    let notice: String?
    let totalCount: Int?

    enum CodingKeys: String, CodingKey {
        case timestamp, notice, elapsed, totalCount
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case creditCount = "credit_count"
    }
}
