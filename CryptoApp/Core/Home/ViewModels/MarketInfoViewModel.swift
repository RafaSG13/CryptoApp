//
//  MarketInfoViewModel.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import Foundation
import Combine


class MarketInfoViewModel: ObservableObject {

    @Published var statistics: [Statistic] = []

    private let marketDataSource: MarketDataSource
    private var cancellables = Set<AnyCancellable>()

    init(marketDataSource: MarketDataSource) {
        self.marketDataSource = marketDataSource
        addSubscribers()
    }
}

private extension MarketInfoViewModel {
    func addSubscribers() {
        marketDataSource.$marketData
            .receive(on: DispatchQueue.main)
            .map(getStats)
            .sink { [weak self] statistics in
                guard let self else { return }
                self.statistics = statistics
            }.store(in: &cancellables)
    }


    func getStats(with data: MarketData?) -> [Statistic] {
        guard let marketData = data else { return [] }
        var stats: [Statistic] = []
        let marketCapStat = Statistic(title: "Market Cap",
                                      value: marketData.quote.usd.totalMarketCap.formattedWithAbbreviations(),
                                      percentageChange: marketData.quote.usd.totalMarketCapYesterdayPercentageChange)

        let volume24H = Statistic(title: "24H Volume",
                                  value: marketData.quote.usd.totalVolume24H.formattedWithAbbreviations())

        let btcDominance = Statistic(title: "BTC Dominance",
                                     value: marketData.btcDominance.asPercentageString())

        let portfolioValue = Statistic(title: "Portfolio Value",
                                       value: "$0.00")
        stats.append(contentsOf: [marketCapStat, volume24H, btcDominance, portfolioValue])
        return stats
    }
}
