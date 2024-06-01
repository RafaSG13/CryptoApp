//
//  CoinDataSource.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation
import NetworkingModule
import SwiftUI


protocol CoinDataSourceProtocol {
    var allCoins: [Coin] { get }
    var coinMetadata: [Int: Metadata] { get }
    var coinImages: [Int: Data] { get }

    func getCoinsMetadata(coinIds: [Int]) async throws
    func getCoinImages() async
}

class CoinDataSource {
    @Published var allCoins: [Coin] = []
    @Published var coinMetadata: [Int: Metadata] = [:]
    @Published var coinImages: [Int: Data] = [:]

    let imageCache = Cache<String, Data>()

    /// Do nothing implementation for previews
    init(forPreview: Bool? = true) {}

    init() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let coins = try await self.getCoins()
                self.allCoins = coins
                let coinIds = self.allCoins.map { $0.id }
                try await self.getCoinsMetadata(coinIds: coinIds)
                await self.getCoinImages()
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

    func getCoinImages() async {
        let imageUrls = Dictionary(uniqueKeysWithValues: coinMetadata.values.map { ($0.id, $0.logo) })
        for image in imageUrls {

            if let cached = imageCache.value(forKey: image.value) {
                coinImages[image.key] = cached
                continue
            }

            guard let url = URL(string: image.value) else { return }
            let request = URLRequest(url: url)
            let result = await NetworkingManager.shared.request(with: request)

            switch result {
            case .success(let data):
                imageCache.insert(data, forKey: image.value) // inserta un objeto en cache tal que Object("https://s2.coinmarketcap.com/static/img/coins/64x64/52.png": ImageData)
                coinImages[image.key] = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CoinDataSource {
    private enum NetworkingError: Error {
        case requestError(error: Error)
    }
}
