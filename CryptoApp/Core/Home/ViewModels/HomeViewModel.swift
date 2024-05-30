//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoin: [Coin] = []

    private let dataSource: CoinDataSource
    private var cancellables = Set<AnyCancellable>()

    init(with datasource: CoinDataSource) {
        self.dataSource = datasource
        addSubscribers()
    }

    func addSubscribers() {
        Task { [weak self] in
            guard let self else { return }

            self.dataSource.$allCoins
                .receive(on: DispatchQueue.main)
                .sink {  [weak self] (coinList) in
                self?.allCoins = coinList
            }.store(in: &cancellables)
        }
    }

}
