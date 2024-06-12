//
//  CoinPreviewMock.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation

class CoinPreviewMock {
    static func instance() -> Coin{
        let mockCoin = Coin(
            id: 1,
            name: "Bitcoin",
            symbol: "BTC",
            slug: "bitcoin",
            numMarketPairs: 11077,
            dateAdded: "2010-07-13T00:00:00.000Z",

            tags: [
                "mineable",
                "pow",
                "sha-256",
                "store-of-value",
                "state-channel",
                "coinbase-ventures-portfolio",
                "three-arrows-capital-portfolio",
                "polychain-capital-portfolio",
                "binance-labs-portfolio",
                "blockchain-capital-portfolio",
                "boostvc-portfolio",
                "cms-holdings-portfolio",
                "dcg-portfolio",
                "dragonfly-capital-portfolio",
                "electric-capital-portfolio",
                "fabric-ventures-portfolio",
                "framework-ventures-portfolio",
                "galaxy-digital-portfolio",
                "huobi-capital-portfolio",
                "alameda-research-portfolio",
                "a16z-portfolio",
                "1confirmation-portfolio",
                "winklevoss-capital-portfolio",
                "usv-portfolio",
                "placeholder-ventures-portfolio",
                "pantera-capital-portfolio",
                "multicoin-capital-portfolio",
                "paradigm-portfolio",
                "bitcoin-ecosystem",
                "ftx-bankruptcy-estate"
            ],
            maxSupply: 21000000,
            circulatingSupply: 19705546,
            totalSupply: 19705546,
            platform: nil,
            cmcRank: 1,
            lastUpdated: "2024-05-30T11:18:00.000Z",
            quote: [
                "USD": Quote(
                    price: 67882.24827636885,
                    volume24h: 27213417793.316338,
                    volumeChange24h: -4.4934,
                    percentChange1h: 0.44043132,
                    percentChange24h: 0.12516932,
                    percentChange7d: -2.60367037,
                    percentChange30d: 10.31293411,
                    percentChange60d: -3.56995941,
                    percentChange90d: 9.37392208,
                    marketCap: 1337656765993.407,
                    marketCapDominance: 52.9045,
                    fullyDilutedMarketCap: 1425527213803.75,
                    tvl: 23
                )
            ]
        )
        return mockCoin
    }
}

