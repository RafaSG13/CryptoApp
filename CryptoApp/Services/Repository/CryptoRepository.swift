//
//  CryptoRepository.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 12/6/24.
//

import Foundation
import Combine


final class CryptoRepository: ObservableObject {
    private let coinDataSource: CoinDataSourceProtocol
    private let marketDataSource: MarketDataSourceProtocol
    private let portfolioDataSource: PortfolioDataSource = PortfolioDataSource()

    @Published var coins: [Coin] = []
    @Published private var metadata: [Int: Metadata] = [:]
    @Published private var images: [Int: Data] = [:]
    @Published private var market: MarketData? = nil

    var allCoins: Published<[Coin]>.Publisher { $coins }
    var coinsMetadata: Published<[Int: Metadata]>.Publisher { $metadata }
    var coinImages: Published<[Int: Data]>.Publisher { $images }
    var marketData: Published<MarketData?>.Publisher { $market}
    var portfolioCoin: Published<[Portfolio]>.Publisher { portfolioDataSource.portfolioEntitiesDriver}
    private var cancellables = Set<AnyCancellable>()



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
        market = try await marketDataSource.getMarketData()
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


extension CryptoRepository {

    func addSubscribers() {
        addCoinMetadataSubscriber()
        addCoinImagesSubscriber()
//        addAllCoinAndSearchSubscriber()
        addPortfolioSubscriber()
//        addMarketSubscriber()
    }

    func addPortfolioSubscriber() {
        $coins
            .combineLatest(portfolioCoin)
            .map { (coinModels, portfolioEntities) -> [Coin] in
                coinModels.compactMap { coin -> Coin? in
                    guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else { return nil }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }.sink(receiveValue: { [weak self] returnedCoins in
                self?.portfolioCoin = returnedCoins
            }).store(in: &cancellables)
    }

//    func addAllCoinAndSearchSubscriber() {
//        //El filtrado no funciona por que se hace en el datasource cuando hace el fetch
//        $searchText
//            .combineLatest(coins, $sortOption)
//            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
//            .map(filterAndSortCoins)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] coinList in
//                guard let self else { return }
//                self.coins = coinList
//            }.store(in: &cancellables)
//
//    }

    func addCoinImagesSubscriber() {
        $images
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coinImages in
                guard let self else { return }
                self.images = coinImages
            }).store(in: &cancellables)
    }

    func addCoinMetadataSubscriber() {
        $metadata
            .receive(on: DispatchQueue.main)
            .sink { [weak self] metadata in
                guard let self else { return }
                self.metadata = metadata
            }.store(in: &cancellables)
    }

    func addMarketSubscriber() {
        $market
            .combineLatest($portfolioCoin)
            .receive(on: DispatchQueue.main)
            .map(getStats)
            .sink { [weak self] statistics in
                guard let self else { return }
                self.statistics = statistics
            }.store(in: &cancellables)
    }

}

private extension CryptoRepository {
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
