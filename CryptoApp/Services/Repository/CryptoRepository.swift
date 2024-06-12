//
//  CryptoRepository.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 12/6/24.
//

import Foundation


final class CryptoRepository: ObservableObject {
    private let coinDataSource: CoinDataSourceProtocol
    private let marketDataSource: MarketDataSourceProtocol
    private let portfolioDataSource: PortfolioDataSource = PortfolioDataSource()

    @Published var coins: [Coin] = []
    @Published private var metadata: [Int: Metadata] = [:]
    @Published private var images: [Int: Data] = [:]

    var allCoins: Published<[Coin]>.Publisher { $coins }
    var coinsMetadata: Published<[Int: Metadata]>.Publisher { $metadata }
    var coinImages: Published<[Int: Data]>.Publisher { $images }
    var marketData: Published<MarketData?>.Publisher { marketDataSource.marketDataDriver}
    var portfolioCoin: Published<[Portfolio]>.Publisher { portfolioDataSource.portfolioEntitiesDriver}


    init(coinDataSource: CoinDataSourceProtocol, marketDataSource: MarketDataSourceProtocol) {
        self.coinDataSource = coinDataSource
        self.marketDataSource = marketDataSource
    }

    public func getCoinInfo() async throws {
        coins = try await coinDataSource.getCoins()
        metadata = try await coinDataSource.getCoinsMetadata()
        images = await coinDataSource.getCoinImages()
    }

    public func getMarketInfo() async throws {
        try await marketDataSource.getMarketData()
    }

    func getRemoteCoinImage(coinId: Int) -> Data? {
        return images[coinId]
    }

    func getRemoteCoinMetadata(coinId: Int) -> Metadata? {
        return metadata[coinId]
    }

    public func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataSource.updatePortFolio(coin: coin, amount: amount)
    }
}
