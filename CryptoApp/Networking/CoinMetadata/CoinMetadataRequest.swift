//
//  CoinMetadataRequest.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import Foundation

final class CoinMetadataEndpoint {
    private let queryData: CoinMetadataRequestData
    private let basePath: String = "https://pro-api.coinmarketcap.com"
    private let endpoint: String = "/v2/cryptocurrency/info"

    private var parameters: [String: String]

    private var headers: [String: String] = [
        "X-CMC_PRO_API_KEY": PrivateConfig.apiKey
    ]

    init(with queryData: CoinMetadataRequestData){
        self.queryData = queryData
        self.parameters = [ "id" : queryData.id ]
    }

    func createUrlRequest() -> URLRequest? {
        guard let url = createUrl() else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

    func createUrl() -> URL? {
        var urlComponents = URLComponents(string: basePath + endpoint)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = urlComponents?.url else { return nil }
        return url
    }
}

final class CoinMetadataRequestData {
    var id: String = ""
    private let coinIds: [Int]

    init(coinIds: [Int]) {
        self.coinIds = coinIds
        getIds()
    }

    func getIds() {
        for coinId in coinIds {
            self.id = id + String(coinId) + ","
        }
        self.id.removeLast()
    }
}
