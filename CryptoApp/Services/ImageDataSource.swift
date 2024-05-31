//
//  ImageDataSource.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation
import SwiftUI
import NetworkingModule


final class ImageDataSource {
    @Published var coinLogo: UIImage?
    @Binding private var coinMetadata: [Int: Metadata]

    init(coinMetadata: Binding<[Int: Metadata]>) {
        self._coinMetadata = coinMetadata
    }

    func getImage(for coin: Coin) async throws -> UIImage {

         if let cached = coinLogo {
             return cached
         }

        guard let coinLogoString = coinMetadata[coin.id]?.logo else { throw URLError(.badURL) }
        guard let url = URL(string: coinLogoString) else { throw URLError(.badURL) }
         let request = URLRequest(url: url)
         let result = await NetworkingManager.shared.request(with: request)

         switch result {
         case .success(let data):
             guard let image = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
             coinLogo = image
             return image
         case .failure(let error):
             print(error.localizedDescription)
             throw URLError(.badServerResponse)
         }
     }



}
