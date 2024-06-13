//
//  PortfolioDataSourceMock.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 13/6/24.
//

import Foundation
import Combine

final class PortfolioDataSourceMock: PortfolioDataSourceProtocol {
    @Published private var savedEntities: [Portfolio] = []
    var portfolioDriver: Published<[Portfolio]>.Publisher { $savedEntities }

    func updatePortFolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                updateCoin(entity: entity, amount: amount)
            } else {
                deleteCoin(entity: entity)
            }
        } else {
            addCoin(coin: coin, amount: amount)
        }
    }

    // Mock-specific methods to manipulate data
    private func addCoin(coin: Coin, amount: Double) {
        let entity = Portfolio()
        entity.coinId = Int64(coin.id)
        entity.amount = amount
        savedEntities.append(entity)
    }

    private func updateCoin(entity: Portfolio, amount: Double) {
        if let index = savedEntities.firstIndex(where: { $0.coinId == entity.coinId }) {
            savedEntities[index].amount = amount
        }
    }

    private func deleteCoin(entity: Portfolio) {
        if let index = savedEntities.firstIndex(where: { $0.coinId == entity.coinId }) {
            savedEntities.remove(at: index)
        }
    }
}
