//
//  MetadataPreviewMock.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 31/5/24.
//

import Foundation
class MetadataMock {
    static func instance() -> Metadata {
        return Metadata(
            id: 1,
            name: "Bitcoin",
            symbol: "BTC",
            category: "Cryptocurrency",
            description: "Bitcoin is a decentralized digital currency.",
            slug: "bitcoin",
            logo: "https://example.com/logo.png",
            notice: "No known notices.",
            dateAdded: "2009-01-03"
        )
    }
}
