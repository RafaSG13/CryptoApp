//
//  CryptoRepository.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 12/6/24.
//

import Combine
import Foundation
import SwiftUI

final class CryptoRepository {
    private let coinDataSource: CoinDataSourceProtocol
    private let marketDataSource: MarketDataSourceProtocol
    private let portfolioDataSource: PortfolioDataSourceProtocol

    var coins: Published<[Coin]>.Publisher { coinDataSource.coinDriver }
    var coinsMetadata: Published<[Int: Metadata]>.Publisher { coinDataSource.metadataDriver }
    var coinImages: Published<[Int: Data]>.Publisher { coinDataSource.imagesDriver }
    var marketData: Published<MarketData?>.Publisher { marketDataSource.driver }
    var portfolioCoins: Published<[Portfolio]>.Publisher { portfolioDataSource.portfolioDriver }


    init(coinDataSource: CoinDataSourceProtocol,
         marketDataSource: MarketDataSourceProtocol,
         portfolioDataSource: PortfolioDataSourceProtocol) {
        self.coinDataSource = coinDataSource
        self.marketDataSource = marketDataSource
        self.portfolioDataSource = portfolioDataSource
    }

    @MainActor
    public func getCoinInfo() async throws {
        try await coinDataSource.fetchCoins()
        try await coinDataSource.fetchMetadata()
        await coinDataSource.fetchCoinImages()
    }

    @MainActor
    public func getMarketInfo() async throws {
        try await marketDataSource.fetchMarketData()
    }

    func getCoinImage(coinId: Int) -> Data? {
        let coinImages = coinDataSource.readImages()
        guard let data = coinImages[coinId] else { return nil }
        return data
    }

    func getCoinMetadata(coinId: Int) -> Metadata? {
        let coinMetadata = coinDataSource.readMetadata()
        return coinMetadata[coinId]
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataSource.updatePortFolio(coin: coin, amount: amount)
    }

    func updateCoins(with newCoins: [Coin]) {
        coinDataSource.updateCoins(newCoins)
    }    

    func updateMetadata(with newMetadata: [Int: Metadata]) {
        coinDataSource.updateMetadata(newMetadata)
    }

    func updateImages(with newImages: [Int: Data]) {
        coinDataSource.updateImages(newImages)
    }
}
