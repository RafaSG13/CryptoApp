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

    func getCoins() async throws {
        coins = [CoinPreviewMock.instance(), CoinPreviewMock.instance(), CoinPreviewMock.instance()]
    }

    func getCoinsMetadata() async throws {
        metadata = [1: MetadataMock.instance(), 2: MetadataMock.instance(), 3: MetadataMock.instance()]
    }

    func getCoinImages() async {
        guard let uiImage = UIImage(named: "CoinImageMock"),
        let data = uiImage.pngData() else { return }
        images = [1: data, 2: data, 3: data]
    }
}
