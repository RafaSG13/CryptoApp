//
//  CoinDataSourceMock.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 12/6/24.
//

import Foundation
import SwiftUI

final class CoinDataSourceMock: CoinDataSourceProtocol {
    private var images: [Int: Data] = [:]

    func getCoins() async throws -> [Coin]{
        return [CoinPreviewMock.instance(), CoinPreviewMock.instance(), CoinPreviewMock.instance()]
    }

    func getCoinsMetadata() async throws -> [Int: Metadata] {
       return [1: MetadataMock.instance(), 2: MetadataMock.instance(), 3: MetadataMock.instance()]

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
        return MetadataMock.instance()
    }
}
