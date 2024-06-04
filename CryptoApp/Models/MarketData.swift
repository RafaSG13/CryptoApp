//
//  MarketData.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import Foundation

struct MarketData: Codable {
    let btcDominance, ethDominance: Double
    let activeCryptocurrencies, totalCryptocurrencies, activeMarketPairs, activeExchanges, totalExchanges: Int
    let quote: Quote

    enum CodingKeys: String, CodingKey {
        case btcDominance = "btc_dominance"
        case ethDominance = "eth_dominance"
        case activeCryptocurrencies = "active_cryptocurrencies"
        case totalCryptocurrencies = "total_cryptocurrencies"
        case activeMarketPairs = "active_market_pairs"
        case activeExchanges = "active_exchanges"
        case totalExchanges = "total_exchanges"
        case quote
    }


    // MARK: - QuoteQuote
    struct Quote: Codable {
        let usd: Usd

        enum CodingKeys: String, CodingKey {
            case usd = "USD"
        }
    }

    // MARK: - Usd
    struct Usd: Codable {
        let totalMarketCap, totalVolume24H, totalVolume24HReported: Double
        let stableCoinVolume24H, stableCoinVolume24HReported: Double
        let stableCoin24HPercentageChange, stableCoinMarketCap: Double
        let totalMarketCapYesterday, totalVolume24HYesterday, totalMarketCapYesterdayPercentageChange, totalVolume24HYesterdayPercentageChange: Double

        enum CodingKeys: String, CodingKey {
            case totalMarketCap = "total_market_cap"
            case totalVolume24H = "total_volume_24h"
            case totalVolume24HReported = "total_volume_24h_reported"
            case stableCoinVolume24H = "stablecoin_volume_24h"
            case stableCoinVolume24HReported = "stablecoin_volume_24h_reported"
            case stableCoin24HPercentageChange = "stablecoin_24h_percentage_change"
            case stableCoinMarketCap = "stablecoin_market_cap"
            case totalMarketCapYesterday = "total_market_cap_yesterday"
            case totalVolume24HYesterday = "total_volume_24h_yesterday"
            case totalMarketCapYesterdayPercentageChange = "total_market_cap_yesterday_percentage_change"
            case totalVolume24HYesterdayPercentageChange = "total_volume_24h_yesterday_percentage_change"
        }
    }
}
