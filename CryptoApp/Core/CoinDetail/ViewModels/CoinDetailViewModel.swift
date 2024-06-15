//
//  CoinDetailViewModel.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 9/6/24.
//

import Foundation
import Combine
import SwiftUI


final class CoinDetailViewModel: ObservableObject {
    private let repository: CryptoRepository
    let coin: Coin

    @Published var overViewStats: [Statistic] = []
    @Published var additionalStats: [Statistic] = []

    init(coin: Coin, repository: CryptoRepository) {
        self.repository = repository
        self.coin = coin
    }


    func getCoinImage() -> UIImage {
        guard let data = repository.getCoinImage(coinId: coin.id),
              let uiImage = UIImage(data: data) else { return UIImage(systemName: "bitcoinsign.arrow.circlepath")! }
        return uiImage
    }

    @MainActor func setViewModel() {
        getStats()
    }

    @MainActor
    func getStats() {
        overViewStats.removeAll()
        additionalStats.removeAll()

        guard let usd = coin.quote["USD"] else { return }
        let volumeStats = Statistic(title: "Volume 24H", value: usd.volume24h.formattedWithAbbreviations(), percentageChange: usd.volumeChange24h)
        let priceStat = Statistic(title: "Current Price", value: usd.price.asCurrencyWith2Decimals(), percentageChange: usd.percentChange24h)
        let marketCapStat = Statistic(title: "Market Cap", value: usd.marketCap.formattedWithAbbreviations(), percentageChange: usd.marketCapDominance)
        let rankStat = Statistic(title: "Rank", value: String(coin.cmcRank))
        let tlvStat = Statistic(title: "Tlv", value: String(usd.tvl ?? 0.0))

        overViewStats.append(contentsOf: [rankStat, priceStat])
        additionalStats.append(contentsOf: [marketCapStat, volumeStats, tlvStat])
    }

    func getCoinChartData() -> [CoinChartData]{
        guard let info = coin.quote["USD"] else { return [] }

        let data1h = CoinChartData(id: .init(), daysAgo: 0, value: info.percentChange1h)
        let data1d = CoinChartData(id: .init(), daysAgo: 1, value: info.percentChange24h)
        let data7d = CoinChartData(id: .init(), daysAgo: 7, value: info.percentChange7d)
        let data30d = CoinChartData(id: .init(), daysAgo: 30, value: info.percentChange30d)
        let data60d = info.percentChange60d != nil ? CoinChartData(id: .init(), daysAgo: 60, value: info.percentChange60d!) : nil
        let data90d = info.percentChange90d != nil ? CoinChartData(id: .init(), daysAgo: 90, value: info.percentChange90d!) : nil

        let chartData = [data1h, data1d, data7d, data30d, data60d, data90d].compactMap { $0 }
        return chartData
    }

}
