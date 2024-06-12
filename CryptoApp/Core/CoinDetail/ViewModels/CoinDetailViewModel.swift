//
//  CoinDetailViewModel.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 9/6/24.
//

import Foundation


class CoinDetailViewModel: ObservableObject {
    private let coinDataSource: CoinDataSourceProtocol
    let coin: Coin

    @Published var overViewStats: [Statistic] = []
    @Published var additionalStats: [Statistic] = []

    init(coin: Coin, coinDataSource: CoinDataSourceProtocol) {
        self.coinDataSource = coinDataSource
        self.coin = coin
    }


    ///HAY QUE CREAR UN METODO QUE TE DE EL ARRAY DE ESTADISTICAS QUE TU QUIERAS DE LA COIN SELECCIONADA
    ///EN RELACION CON LAS STATS
}

