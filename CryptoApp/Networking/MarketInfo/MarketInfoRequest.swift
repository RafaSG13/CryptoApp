//
//  MarketInfoRequest.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import Foundation

final class MarketInfoEndPoint {
    private let basePath: String = "https://pro-api.coinmarketcap.com"
    private let endpoint: String = "/v1/global-metrics/quotes/latest"

    private var headers: [String: String] = [
        "X-CMC_PRO_API_KEY": PrivateConfig.apiKey
    ]

    init(){}

    func createUrlRequest() -> URLRequest? {
        guard let url = createUrl() else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

    func createUrl() -> URL? {
        let urlComponents = URLComponents(string: basePath + endpoint)
        guard let url = urlComponents?.url else { return nil }
        return url
    }
}
