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

}
