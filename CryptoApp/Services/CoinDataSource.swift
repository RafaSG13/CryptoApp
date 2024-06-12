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
    var allCoins: Published<[Coin]>.Publisher { get }
    var coinMetadata: Published<[Int: Metadata]>.Publisher { get }
    var coinImages: Published<[Int: Data]>.Publisher { get }

    func getCoins() async throws
    func getCoinsMetadata() async throws
    func getCoinImages() async
}

class CoinDataSource: CoinDataSourceProtocol {
    @Published private var coins: [Coin] = []
    @Published private var metadata: [Int: Metadata] = [:]
    @Published private var images: [Int: Data] = [:]

    var allCoins: Published<[Coin]>.Publisher { $coins }
    var coinMetadata: Published<[Int: Metadata]>.Publisher { $metadata }
    var coinImages: Published<[Int: Data]>.Publisher { $images }

    let imageCache = Cache<String, Data>()

    init() {}

    func getCoins() async throws {
        let endpoint = CoinListingRequestEndpoint()
        guard let request = endpoint.createUrlRequest() else { throw URLError(.badURL) }

        let result = await NetworkingManager.shared.request(with: request)
        switch result {
        case .success(let data):
            let coinListingResponse = try JSONDecoder().decode(CoinListingResponse.self, from: data)
            self.coins = Array(coinListingResponse.data)
        case.failure(let error):
            print("Error in parsing response \(error)")
            throw NetworkingError.requestError(error: error)
        }
    }

    func getCoinsMetadata() async throws {
        let coinIds = self.coins.map{ $0.id }
        guard !coinIds.isEmpty else { return }

        let queryData = CoinMetadataRequestData(coinIds: coinIds)
        let endpoint = CoinMetadataEndpoint(with: queryData)
        guard let request = endpoint.createUrlRequest() else { return }
        let result = await NetworkingManager.shared.request(with: request)
        switch result {
        case .success(let data):
            do {
                let response = try JSONDecoder().decode(CoinMetadataResponse.self, from: data)
                self.metadata = Dictionary(uniqueKeysWithValues: response.data.values.map { ($0.id, $0) })
            } catch {
                throw URLError(.badServerResponse)
            }
        case .failure(let error):
            throw NetworkingError.responseError(error: error)
        }
    }

    func getCoinImages() async {
        let imageUrls = Dictionary(uniqueKeysWithValues: metadata.values.map { ($0.id, $0.logo) })
        for image in imageUrls {

            if let cached = imageCache.value(forKey: image.value) {
                images[image.key] = cached
                continue
            }

            guard let url = URL(string: image.value) else { return }
            let request = URLRequest(url: url)
            let result = await NetworkingManager.shared.request(with: request)

            switch result {
            case .success(let data):
                imageCache.insert(data, forKey: image.value) // inserta un objeto en cache tal que Object("https://s2.coinmarketcap.com/static/img/coins/64x64/52.png": ImageData)
                images[image.key] = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CoinDataSource {
    private enum NetworkingError: Error {
        case requestError(error: Error)
        case responseError(error: Error)
    }
}
