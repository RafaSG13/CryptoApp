//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation
import Combine
import SwiftUI


class CoinViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoin: [Coin] = []

    @Published var isLoading: Bool = false
    @Published var coinMetadata: [Int: Metadata] = [:]

    private let dataSource: CoinDataSource
    private var cancellables = Set<AnyCancellable>()

    init(with datasource: CoinDataSource) {
        self.dataSource = datasource
        addSubscribers()
    }

    private func addSubscribers() {
        dataSource.$allCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coinList in
                self?.allCoins = coinList
            }
            .store(in: &cancellables)

        dataSource.$coinMetadata
            .receive(on: DispatchQueue.main)
            .sink { [weak self] metadata in
                guard let self else { return }
                self.coinMetadata = metadata
            }
            .store(in: &cancellables)
    }


    func getCoinMetadata(for coinId: Int) -> Metadata? {
        return coinMetadata[coinId]
    }
}
