//
//  CoinDataSourceMock.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 12/6/24.
//

import Foundation
import SwiftUI

final class CoinDataSourceMock: CoinDataSourceProtocol {
    @Published var coins: [Coin] = []
    @Published var images: [Int: Data] = [:]
    @Published var metadata: [Int: Metadata] = [:]

    var coinDriver: Published<[Coin]>.Publisher { $coins }
    var imagesDriver: Published<[Int : Data]>.Publisher { $images }
    var metadataDriver: Published<[Int : Metadata]>.Publisher { $metadata }
    
    func fetchCoins() async throws {
        //Unimplemented
    }
    
    func fetchMetadata() async throws {
        //Unimplemented
    }
    
    func fetchCoinImages() async {
        //Unimplemented
    }
    
    func readCoins() -> [Coin] {
        return [CoinPreviewMock.instance(), CoinPreviewMock.instance(), CoinPreviewMock.instance()]
    }
    
    func readImages() -> [Int : Data] {
        guard let uiImage = UIImage(named: "CoinImageMock"),
              let data = uiImage.pngData() else { return [:] }
        images = [1: data, 2: data, 3: data]
        return images
    }
    
    func readMetadata() -> [Int : Metadata] {
        return [1: MetadataMock.instance(), 2: MetadataMock.instance(), 3: MetadataMock.instance()]

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

    func getRemoteCoinImage(coinId: Int) -> Data? {
        return images[coinId]
    }

    func getRemoteCoinMetadata(coinId: Int) -> Metadata? {
        return MetadataMock.instance()
    }
}
