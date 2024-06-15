//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 4/6/24.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    @State var repository: CryptoRepository

    var body: some View {
        ZStack {
            if let coin = coin {
                CoinDetailView(coin: coin, repository: repository)
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

    init(coin: Coin, repository: CryptoRepository) {
        self.coin = coin
        _detailVM = StateObject(wrappedValue: CoinDetailViewModel(coin: coin, repository: repository))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(coin.name)
                    .frame(alignment: .topLeading)
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.theme.accentColor)
                    .padding(.vertical)

                ChartView(data: detailVM.getCoinChartData())
                    .frame(maxWidth: .infinity, idealHeight: 150, alignment: .topLeading)

                overViewTitle
                Divider()
                overViewGrid

                additionDetailsTitle
                Divider()
                additionalGrid

            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Text(coin.symbol)
                        .font(.headline)
                        .foregroundStyle(Color.theme.accentColor)
                    CircularImageView(coinLogo: detailVM.getCoinImage())
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.theme.accentColor)
                }
            }
        }
        .task {
            detailVM.setViewModel()
        }
     }
}

//FIXME: ARREGLAR ESTo
//#Preview {
//    CoinDetailView(coin:CoinPreviewMock.instance(), repository: )
//}


extension CoinDetailView {
    private var overViewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var overViewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: ViewConstants.gridSpacing,
                  content: {
            ForEach(detailVM.overViewStats) { stat in
                StatisticView(stat: stat)
            }
        })
    }

    private var additionDetailsTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: ViewConstants.gridSpacing,
                  content: {
            ForEach(detailVM.additionalStats) { stat in
                StatisticView(stat: stat)
            }
        })
    }
}
