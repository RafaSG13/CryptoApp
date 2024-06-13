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
    var coinDriver: Published<[Coin]>.Publisher { get }
    var imagesDriver: Published<[Int: Data]>.Publisher { get }
    var metadataDriver: Published<[Int: Metadata]>.Publisher { get }

    func fetchCoins() async throws
    func fetchMetadata() async throws
    func fetchCoinImages() async

    func readCoins() -> [Coin]
    func readImages() -> [Int: Data]
    func readMetadata() -> [Int: Metadata]

    func updateCoins(_ coins: [Coin])
    func updateImages(_ images: [Int: Data])
    func updateMetadata(_ metadata: [Int: Metadata])
}

final class CoinDataSource: CoinDataSourceProtocol {
    @Published private var coins: [Coin] = []
    @Published private var metadata: [Int: Metadata] = [:]
    @Published private var images: [Int: Data] = [:]

    var coinDriver: Published<[Coin]>.Publisher { $coins }
    var imagesDriver: Published<[Int : Data]>.Publisher { $images }
    var metadataDriver: Published<[Int : Metadata]>.Publisher { $metadata}



    let imageCache = Cache<String, Data>()

    func fetchCoins() async throws {
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

    func fetchMetadata() async throws  {
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

    func fetchCoinImages() async {
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

    func readCoins() -> [Coin] {
        return coins
    }

    func readImages() -> [Int : Data] {
        return images
    }

    func readMetadata() -> [Int : Metadata] {
        return metadata
    }

    func updateCoins(_ coins: [Coin]) {
        self.coins = coins
    }

    func updateImages(_ images: [Int : Data]) {
        self.images = images
    }

    func updateMetadata(_ metadata: [Int : Metadata]) {
        self.metadata = metadata
    }
}

extension CoinDataSource {
    private enum NetworkingError: Error {
        case requestError(error: Error)
        case responseError(error: Error)
    }
}
