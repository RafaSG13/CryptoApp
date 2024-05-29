//
//  CoinListingRequest.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import Foundation


final class CoinListingRequestEndpoint {
    private let basePath: String = "https://pro-api.coinmarketcap.com"
    private let endpoint: String = "/v1/cryptocurrency/listings/latest"

    private var parameters: [String: String] = [
        "cryptocurrency_type" : "coins",
        "limit" : "50"
    ]

    private var headers: [String: String] = [
        "X-CMC_PRO_API_KEY": PrivateConfig.apiKey
    ]

    init(){}

    private func createUrlRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: basePath + endpoint)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = urlComponents?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}
