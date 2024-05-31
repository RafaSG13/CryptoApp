//
//  CoinMetadataResponse.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation

// MARK: - CoinMetadataResponse
struct CoinMetadataResponse: Codable {
    let status: Status
    let data: [Int: Metadata]
}

// MARK: - Datum
struct Metadata: Codable {
    let id: Int
    let name, symbol, category, description: String
    let slug: String
    let logo: String
    let notice: String
    let urls: Urls
    let dateAdded: String
    let isHidden: Int


    enum CodingKeys: String, CodingKey {
        case id, name, symbol, category, description, slug, logo, notice
        case urls
        case dateAdded = "date_added"
        case isHidden = "is_hidden"
    }
}

// MARK: - Urls
struct Urls: Codable {
    let website: [String]
    let twitter, messageBoard: [String]
    let explorer: [String]
    let reddit: [String]
    let technicalDoc: [String]
    let sourceCode: [String]
    let announcement: [String]

    enum CodingKeys: String, CodingKey {
        case website, twitter
        case messageBoard = "message_board"
        case explorer, reddit
        case technicalDoc = "technical_doc"
        case sourceCode = "source_code"
        case announcement
    }
}
