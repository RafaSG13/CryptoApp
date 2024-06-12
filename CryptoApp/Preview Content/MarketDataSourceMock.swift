//
//  MarketDataSourceMock.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 12/6/24.
//

import Foundation
import SwiftUI

final class MarketDataSourceMock: MarketDataSourceProtocol {
    @Published private var marketData: MarketData? = nil
    var marketDataDriver: Published<MarketData?>.Publisher { $marketData }

    func getMarketData() async throws {
        marketData = MarketDataMock.instance()
    }
}
