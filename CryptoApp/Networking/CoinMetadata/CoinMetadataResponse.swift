//
//  CoinMetadataResponse.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation

// MARK: - CoinMetadataResponse
struct CoinMetadataResponse: Codable {
    let status: Status
    let data: [Int: Metadata]
}
