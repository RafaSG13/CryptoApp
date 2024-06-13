//
//  MarketDataPreviewMock.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 12/6/24.
//

import Foundation

class MarketDataMock {
    static func instance() -> MarketData {
        return MarketData(
            btcDominance: 45.5,
            ethDominance: 19.3,
            activeCryptocurrencies: 5000,
            totalCryptocurrencies: 10000,
            activeMarketPairs: 25000,
            activeExchanges: 200,
            totalExchanges: 300,
            quote: MarketData.Quote(
                usd: MarketData.Usd(
                    totalMarketCap: 2000000000000.0,
                    totalVolume24H: 80000000000.0,
                    totalVolume24HReported: 75000000000.0,
                    stableCoinVolume24H: 20000000000.0,
                    stableCoinVolume24HReported: 19000000000.0,
                    stableCoin24HPercentageChange: 1.5,
                    stableCoinMarketCap: 100000000000.0,
                    totalMarketCapYesterday: 1950000000000.0,
                    totalVolume24HYesterday: 78000000000.0,
                    totalMarketCapYesterdayPercentageChange: 2.5,
                    totalVolume24HYesterdayPercentageChange: 1.0
                )
            )
        )
    }
}
