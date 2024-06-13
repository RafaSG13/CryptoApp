//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation
import Combine
import SwiftUI

protocol HomeViewModelProtocol: ObservableObject {
    var allCoins: [Coin]  { get }
    var portfolioCoin: [Coin]  { get }
    var searchText: String  { get }
    var isLoading: Bool  { get }
    var coinMetadata: [Int: Metadata]  { get }
    var coinImages: [Int: Data]  { get }

    func getCoinImage(for coin: Int) -> UIImage?
}


class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoin: [Coin] = []
    @Published var images: [Int: Data] = [:]
    @Published var metadata: [Int: Metadata] = [:]


    @Published var statistics: [Statistic] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortingOptions = .holdings
    private var cancellables = Set<AnyCancellable>()


    let repository: CryptoRepository

    enum SortingOptions {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }

    init(with repository: CryptoRepository) {
        self.repository = repository
    }

    public func setViewModel() async throws {
        await addSubscribers()
        try await repository.getCoinInfo()
        try await repository.getMarketInfo()
    }

    func getCoinImage(for coin: Int) -> UIImage? {
        guard let data = repository.getCoinImage(coinId: coin),
              let image = UIImage(data: data) else { return nil }
        return image
    }


    func updatePortfolio(coin: Coin, amount: Double) {
        repository.updatePortfolio(coin: coin, amount: amount)
    }

    //FIXME: No funciona
    func reloadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                self.isLoading = true
                try await repository.getMarketInfo()
                try await repository.getCoinInfo()
                self.isLoading = false
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
        HapticManager.notification(type: .success)
    }
}

//MARK: Private Methods

private extension HomeViewModel {

    func getStats(with data: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        guard let marketData = data else { return [] }
        var stats: [Statistic] = []
        let marketCapStat = Statistic(title: "Market Cap",
                                      value: marketData.quote.usd.totalMarketCap.formattedWithAbbreviations(),
                                      percentageChange: marketData.quote.usd.totalMarketCapYesterdayPercentageChange)

        let volume24H = Statistic(title: "24H Volume",
                                  value: marketData.quote.usd.totalVolume24H.formattedWithAbbreviations())

        let btcDominance = Statistic(title: "BTC Dominance",
                                     value: marketData.btcDominance.asPercentageString())

        let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)

        let portfolioStat = Statistic(title: "Portfolio Value",
                                       value: portfolioValue.asCurrencyWith2Decimals())
        stats.append(contentsOf: [marketCapStat, volume24H, btcDominance, portfolioStat])
        return stats
    }

    func filterAndSortCoins(text: String, coins: [Coin], sortOption: SortingOptions) -> [Coin] {
        guard !text.isEmpty else  { return coins }
        let lowercasedText = text.lowercased()
        let filteredCoins = coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.slug.lowercased().contains(lowercasedText)
        }
        switch sortOption {
        case .rank, .holdings:
            return filteredCoins.sorted { $0.cmcRank < $1.cmcRank }
        case .rankReversed, .holdingsReversed:
            return filteredCoins.sorted { $0.cmcRank > $1.cmcRank }
        case .price:
            return filteredCoins.sorted { ($0.quote["USD"]?.price) ?? 0 > ($1.quote["USD"]?.price) ?? 1 }
        case .priceReversed:
            return filteredCoins.sorted { ($0.quote["USD"]?.price) ?? 0 < ($1.quote["USD"]?.price) ?? 1 }
        }
    }

    func getCoinMetadata(for coinId: Int) -> Metadata? {
        return repository.getCoinMetadata(coinId: coinId)
    }

}

// MARK: Subscribers

private extension HomeViewModel {

    @MainActor 
    func addSubscribers() {
        addCoinMetadataSubscriber()
        addCoinImagesSubscriber()
        addAllCoinAndSearchSubscriber()
        addPortfolioSubscriber()
        addMarketSubscriber()
    }

    func addPortfolioSubscriber() {
        repository.coins
            .combineLatest(repository.portfolioCoins)
            .map { (coinModels, portfolioEntities) -> [Coin] in
                coinModels.compactMap { coin -> Coin? in
                    guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else { return nil }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }.assign(to: &$portfolioCoin)
    }

    func addAllCoinAndSearchSubscriber() {
        //Lo que no funciona es el orden
        $searchText
            .combineLatest(repository.coins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .receive(on: DispatchQueue.main)
            .assign(to: &$allCoins)

    }

    func addCoinImagesSubscriber() {
        repository.coinImages
            .receive(on: DispatchQueue.main)
            .assign(to: &$images)
    }

    func addCoinMetadataSubscriber() {
        repository.coinsMetadata
            .receive(on: DispatchQueue.main)
            .assign(to: &$metadata)
    }

    func addMarketSubscriber() {
        repository.marketData
            .combineLatest($portfolioCoin)
            .receive(on: DispatchQueue.main)
            .map(getStats)
            .assign(to: &$statistics)
    }


}
