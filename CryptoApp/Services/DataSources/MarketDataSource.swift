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
    var driver: Published<MarketData?>.Publisher { get }
    func fetchMarketData() async throws
    func read() -> MarketData?
}

final class MarketDataSource: MarketDataSourceProtocol {
    @Published private var marketData: MarketData? = nil
    var driver: Published<MarketData?>.Publisher { $marketData }

    func fetchMarketData() async throws {
        let endpoint = MarketInfoEndPoint()
        guard let request = endpoint.createUrlRequest() else { throw URLError(.badURL) }

        let result = await NetworkingManager.shared.request(with: request)
        switch result {
        case .success(let data):
            let marketInfoResponse = try JSONDecoder().decode(MarketInfoResponse.self, from: data)
            marketData = marketInfoResponse.data
        case.failure(let error):
            print("Error in parsing response \(error)")
            throw NetworkingError.requestError(error: error)
        }
    }

    func read() -> MarketData? {
        return marketData
    }
}

extension MarketDataSource {
    private enum NetworkingError: Error {
        case requestError(error: Error)
    }
}
