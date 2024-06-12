//
//  MarketDataSource.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import Foundation
import NetworkingModule
import SwiftUI


protocol MarketDataSourceProtocol {
    var marketDataDriver: Published<MarketData?>.Publisher { get }
    func getMarketData() async throws
}

class MarketDataSource: MarketDataSourceProtocol {
    
    @Published private var marketData: MarketData? = nil
    var marketDataDriver: Published<MarketData?>.Publisher { $marketData }

    init() {}

    func getMarketData() async throws {
        let endpoint = MarketInfoEndPoint()
        guard let request = endpoint.createUrlRequest() else { throw URLError(.badURL) }

        let result = await NetworkingManager.shared.request(with: request)
        switch result {
        case .success(let data):
            let marketInfoResponse = try JSONDecoder().decode(MarketInfoResponse.self, from: data)
            self.marketData =  marketInfoResponse.data
        case.failure(let error):
            print("Error in parsing response \(error)")
            throw NetworkingError.requestError(error: error)
        }
    }
}

extension MarketDataSource {
    private enum NetworkingError: Error {
        case requestError(error: Error)
    }
}
