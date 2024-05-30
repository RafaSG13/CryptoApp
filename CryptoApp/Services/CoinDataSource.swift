//
//  CoinDataSource.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation
import NetworkingModule
import Combine

protocol CoinDataSourceProtocol {
    var allCoins: [Coin] { get }
}

class CoinDataSource: CoinDataSourceProtocol {
    @Published var allCoins: [Coin] = []
    var cancellable: AnyCancellable?

    init() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let coins = try await self.getCoins()
                self.allCoins = coins
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

    private func getLocalCoins() {
        guard let data = JSONFile.getJSON() else { return }
        do {
            let response = try JSONDecoder().decode(CoinListingResponse.self, from: data)
            response.data.forEach { self.allCoins.append($0) }
            print(allCoins.first!)
        } catch(let error){
            print("Error in parsing response \(error)")
        }
    }
}

extension CoinDataSource {
    private enum NetworkingError: Error {
        case requestError(error: Error)
    }
}
