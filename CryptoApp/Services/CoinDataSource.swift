//
//  CoinDataSource.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation
import NetworkingModule
import SwiftUI

class CoinDataSource {
    @Published var allCoins: [Coin] = []
    @Published var coinMetadata: [Int: Metadata] = [:]

    init() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let coins = try await self.getCoins()
                self.allCoins = coins
                let coinIds = self.allCoins.map { $0.id }
                try await self.getCoinsMetadata(coinIds: coinIds)
            } catch {
                print("Error fetching coins: \(error)")
            }
        }
    }


    private func getCoins() async throws -> [Coin] {
        let endpoint = CoinListingRequestEndpoint()
        guard let request = endpoint.createUrlRequest() else { throw URLError(.badURL) }

        let result = await NetworkingManager.shared.request(with: request)
        switch result {
        case .success(let data):
            let coinListingResponse = try JSONDecoder().decode(CoinListingResponse.self, from: data)
            return Array(coinListingResponse.data)
        case.failure(let error):
            print("Error in parsing response \(error)")
            throw NetworkingError.requestError(error: error)
        }
    }

    func getCoinsMetadata(coinIds: [Int]) async throws {
        let queryData = CoinMetadataRequestData(coinIds: coinIds)
        let endpoint = CoinMetadataEndpoint(with: queryData)
        guard let request = endpoint.createUrlRequest() else { return }
        let result = await NetworkingManager.shared.request(with: request)
        switch result {
        case .success(let data):
            do {
                let response = try JSONDecoder().decode(CoinMetadataResponse.self, from: data)
                self.coinMetadata = Dictionary(uniqueKeysWithValues: response.data.values.map { ($0.id, $0) })
            } catch {
                throw URLError(.badServerResponse)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }

    }
}

extension CoinDataSource {
    private enum NetworkingError: Error {
        case requestError(error: Error)
    }
}
