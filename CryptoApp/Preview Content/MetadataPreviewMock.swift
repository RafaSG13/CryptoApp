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
            urls: Urls(
                website: ["https://bitcoin.org"],
                twitter: ["https://twitter.com/bitcoin"],
                messageBoard: ["https://bitcointalk.org"],
                explorer: ["https://blockchain.info"],
                reddit: ["https://reddit.com/r/bitcoin"],
                technicalDoc: ["https://bitcoin.org/bitcoin.pdf"],
                sourceCode: ["https://github.com/bitcoin/bitcoin"],
                announcement: ["https://bitcoin.org/en/press"]
            ),
            dateAdded: "2009-01-03",
            isHidden: 0
        )
    }
}
