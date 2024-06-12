//
//  CoinDataSourceMock.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 12/6/24.
//

import Foundation
import SwiftUI

final class CoinDataSourceMock: CoinDataSourceProtocol {
    
    @Published private var coins: [Coin] = []

    @Published private var metadata: [Int: Metadata] = [:]

    @Published private var images: [Int: Data] = [:]

    var allCoins: Published<[Coin]>.Publisher { $coins }
    var coinMetadata: Published<[Int: Metadata]>.Publisher { $metadata }
    var coinImages: Published<[Int: Data]>.Publisher { $images }

    func getCoins() async throws -> [Coin]{
        coins = [CoinPreviewMock.instance(), CoinPreviewMock.instance(), CoinPreviewMock.instance()]
        return coins
    }

    func getCoinsMetadata() async throws -> [Int: Metadata] {
        metadata = [1: MetadataMock.instance(), 2: MetadataMock.instance(), 3: MetadataMock.instance()]
        return metadata
    }

    func getCoinImages() async -> [Int: Data] {
        guard let uiImage = UIImage(named: "CoinImageMock"),
              let data = uiImage.pngData() else { return [:] }
        images = [1: data, 2: data, 3: data]
        return images
    }

    func getRemoteCoinImage(coinId: Int) -> Data? {
        return images[coinId]
    }

    func getRemoteCoinMetadata(coinId: Int) -> Metadata? {
        return metadata[coinId]
    }
}
