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
    var driver: Published<MarketData?>.Publisher { $marketData }

    func fetchMarketData() async throws {
        marketData = MarketDataMock.instance()
    }
    
    func read() -> MarketData? {
        return MarketDataMock.instance()
    }

    func getMarketData() async throws {
        marketData = MarketDataMock.instance()
    }
}
