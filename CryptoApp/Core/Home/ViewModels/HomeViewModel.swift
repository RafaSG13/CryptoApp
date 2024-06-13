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
    var allCoins: Published<[Coin]>.Publisher { repository.$coins }
    @Published var portfolioCoin: [Coin] = []

    @Published var statistics: [Statistic] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortingOptions = .holdings

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
        try await repository.getCoinInfo()
        try await repository.getMarketInfo()
    }

    func getCoinImage(for coin: Int) -> UIImage? {
        guard let data = repository.getRemoteCoinImage(coinId: coin),
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
                _ = try await repository.getMarketInfo()
                _ = try await repository.getCoinInfo()
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
        return repository.getRemoteCoinMetadata(coinId: coinId)
    }

}

// MARK: Subscribers

private extension HomeViewModel {


}
