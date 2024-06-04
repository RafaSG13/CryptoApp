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
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var coinMetadata: [Int: Metadata] = [:]
    @Published var coinImages: [Int: Data] = [:]


    private let dataSource: CoinDataSource
    private let portfolioDataService: PortfolioDataSource = PortfolioDataSource()
    private var cancellables = Set<AnyCancellable>()

    init(with datasource: CoinDataSource) {
        self.dataSource = datasource
        addSubscribers()
    }

    func getCoinImage(for coin: Int) -> UIImage? {
        guard let data = coinImages[coin], let image = UIImage(data: data) else { return nil }
        return image
    }

    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortFolio(coin: coin, amount: amount)
    }
}

//MARK: Private Methods

private extension CoinViewModel {

    func addSubscribers() {
        dataSource.$coinMetadata
            .receive(on: DispatchQueue.main)
            .sink { [weak self] metadata in
                guard let self else { return }
                self.coinMetadata = metadata
            }.store(in: &cancellables)

        dataSource.$coinImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
            } receiveValue: { [weak self] coinImages in
                guard let self else { return }
                self.coinImages = coinImages
            }.store(in: &cancellables)

        $searchText
            .combineLatest(dataSource.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
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

        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [Coin] in
                coinModels.compactMap { coin -> Coin? in
                    guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id }) else { return nil }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }.sink { [weak self] _ in
                //nothing
            } receiveValue: { [weak self] returnedCoins in
                self?.portfolioCoin = returnedCoins
            }.store(in: &cancellables)

    }

    func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else  { return coins }
        let lowercasedText = text.lowercased()
        let filteredCoins = coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.slug.lowercased().contains(lowercasedText)
        }
        return filteredCoins
    }

    func getCoinMetadata(for coinId: Int) -> Metadata? {
        return coinMetadata[coinId]
    }
}
