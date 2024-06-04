//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation
import Combine
import SwiftUI

protocol CoinViewModelProtocol: ObservableObject {
    var allCoins: [Coin]  { get }
    var portfolioCoin: [Coin]  { get }
    var searchText: String  { get }
    var isLoading: Bool  { get }
    var coinMetadata: [Int: Metadata]  { get }
    var coinImages: [Int: Data]  { get }

    func getCoinImage(for coin: Int) -> UIImage?
}


class CoinViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoin: [Coin] = []
    @Published var statistics: [Statistic] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var coinMetadata: [Int: Metadata] = [:]
    @Published var coinImages: [Int: Data] = [:]
    @Published var sortOption: SortingOptions = .rank

    private let coinDataSource: CoinDataSource
    private let marketDataSource: MarketDataSource
    private let portfolioDataSource: PortfolioDataSource = PortfolioDataSource()
    private var cancellables = Set<AnyCancellable>()

    enum SortingOptions {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }

    init(with coinDatasource: CoinDataSource, and marketDataSource: MarketDataSource) {
        self.coinDataSource = coinDatasource
        self.marketDataSource = marketDataSource
        addSubscribers()
    }

    func getCoinImage(for coin: Int) -> UIImage? {
        guard let data = coinImages[coin], let image = UIImage(data: data) else { return nil }
        return image
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataSource.updatePortFolio(coin: coin, amount: amount)
    }

    func reloadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                self.isLoading = true
                _ = try await marketDataSource.getMarketData()
                _ = try await coinDataSource.getCoins()
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
        HapticManager.notification(type: .success)
    }
}

//MARK: Private Methods

private extension CoinViewModel {

    func addSubscribers() {
        addCoinMetadataSubscriber()
        addCoinImagesSubscriber()
        addAllCoinAndSearchSubscriber()
        addPortfolioSubscriber()
        addMarketSubscriber()
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
        return coinMetadata[coinId]
    }

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
}

// MARK: Subscribers

private extension CoinViewModel {

    func addPortfolioSubscriber() {
        $allCoins
            .combineLatest(portfolioDataSource.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [Coin] in
                coinModels.compactMap { coin -> Coin? in
                    guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else { return nil }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }.sink(receiveValue: { [weak self] returnedCoins in
                self?.portfolioCoin = returnedCoins
            }).store(in: &cancellables)
    }

    func addAllCoinAndSearchSubscriber() {
        //El filtrado no funciona por que se hace en el datasource cuando hace el fetch
        $searchText
            .combineLatest(coinDataSource.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveSubscription: { [weak self] _ in
                guard let self else { return }
                self.isLoading = true
            }).sink { [weak self] _ in
                guard let self else { return }
                self.isLoading = false
            } receiveValue: { [weak self] coinList in
                guard let self else { return }
                self.allCoins = coinList
            }.store(in: &cancellables)

    }

    func addCoinImagesSubscriber() {
        coinDataSource.$coinImages
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coinImages in
                guard let self else { return }
                self.coinImages = coinImages
            }).store(in: &cancellables)
    }

    func addCoinMetadataSubscriber() {
        coinDataSource.$coinMetadata
            .receive(on: DispatchQueue.main)
            .sink { [weak self] metadata in
                guard let self else { return }
                self.coinMetadata = metadata
            }.store(in: &cancellables)
    }

    func addMarketSubscriber() {
        marketDataSource.$marketData
            .combineLatest($portfolioCoin)
            .receive(on: DispatchQueue.main)
            .map(getStats)
            .sink { [weak self] statistics in
                guard let self else { return }
                self.statistics = statistics
            }.store(in: &cancellables)
    }
}
