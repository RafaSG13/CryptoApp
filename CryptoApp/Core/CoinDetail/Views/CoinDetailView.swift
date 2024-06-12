//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 4/6/24.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    @State var datasource: CoinDataSourceProtocol

    var body: some View {
        ZStack {
            if let coin = coin {
                CoinDetailView(coin: coin, coinDatasource: datasource)
            }
        }
    }
}

struct CoinDetailView: View {
    let coin: Coin
    @StateObject var detailVM: CoinDetailViewModel

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private enum ViewConstants {
        static let gridSpacing: CGFloat = 30
    }

    init(coin: Coin, coinDatasource: CoinDataSourceProtocol) {
        self.coin = coin
        _detailVM = StateObject(wrappedValue: CoinDetailViewModel(coin: coin, coinDataSource: coinDatasource))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(coin.name)
                    .frame(height: 150)

                Text("Overview")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.theme.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()

                LazyVGrid(columns: columns,
                          alignment: .leading,
                          spacing: ViewConstants.gridSpacing,
                          content: {
                    ForEach(0..<6) { _ in
                        StatisticView(stat: StatisticMock.sampleStatistic)
                    }
                })

                Text("Additional Details")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.theme.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          spacing: ViewConstants.gridSpacing,
                          content: {
                    ForEach(0..<6) { _ in
                        StatisticView(stat: StatisticMock.sampleStatistic)
                    }
                })

            }
        }
        .navigationTitle(detailVM.coin.name)
    }
}

#Preview {
    CoinDetailView(coin:CoinPreviewMock.instance(), coinDatasource: CoinDataSourceMock())
}
