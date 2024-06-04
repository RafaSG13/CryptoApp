//
//  CoinMetadata.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import Foundation

struct Metadata: Codable {
    let id: Int
    let name, symbol, category, description: String
    let slug: String
    let logo: String
    let notice: String
    let dateAdded: String

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, category, description, slug, logo, notice
        case dateAdded = "date_added"
    }


}
