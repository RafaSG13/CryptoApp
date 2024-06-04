//
//  CoinModel.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import Foundation

/*
 URL: https://coinmarketcap.com/api/documentation/v1/#operation/getV2CryptocurrencyQuotesLatest
*/

// MARK: - Coin
struct Coin: Codable, Identifiable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let numMarketPairs: Int
    let dateAdded: String
    let tags: [String]
    let maxSupply: Double?
    let circulatingSupply: Double
    let totalSupply: Double
    let platform: String?
    let cmcRank: Int
    let lastUpdated: String
    let quote: [String: Quote]
    var currentHolding: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug, tags, platform, quote
        case numMarketPairs = "num_market_pairs"
        case dateAdded = "date_added"
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case cmcRank = "cmc_rank"
        case lastUpdated = "last_updated"
        case currentHolding
    }

    func updateHoldings(amount: Double) -> Coin {
        return Coin(id: id, name: name, symbol: symbol, slug: slug, numMarketPairs: numMarketPairs, dateAdded: dateAdded, tags: tags, maxSupply: maxSupply, circulatingSupply: circulatingSupply, totalSupply: totalSupply, platform: platform, cmcRank: cmcRank, lastUpdated: lastUpdated, quote: quote, currentHolding: amount)
    }

    var currentHoldingsValue: Double {
        return ((currentHolding ?? 0) * (quote["USD"]?.price ?? 0))
    }
}
