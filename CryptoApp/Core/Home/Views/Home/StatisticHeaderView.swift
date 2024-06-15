//
//  StatisticHeaderView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 31/5/24.
//

import SwiftUI

struct StatisticHeaderView: View {
    @EnvironmentObject private var coinVM: HomeViewModel
    @Binding var showPortfolio: Bool
    @State var maxHeight: CGFloat = .infinity

    var body: some View {
        GeometryReader { proxy in
            HStack {
                ForEach(coinVM.statistics) { stat in
                    StatisticView(stat: stat)
                        .frame(width: proxy.size.width / 3)
                }
            }.frame(width: proxy.size.width,
                    alignment: showPortfolio ? .trailing : .leading)
        }.frame(height: maxHeight)
    }
}

struct StatisticHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel(with: CryptoRepository(coinDataSource: CoinDataSourceMock(),
                                                             marketDataSource: MarketDataSourceMock(),
                                                             portfolioDataSource: PortfolioDataSourceMock()))
        Group {
            StatisticHeaderView(showPortfolio: .constant(false), maxHeight: 50.0)
                .environmentObject(viewModel)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)


            StatisticHeaderView(showPortfolio: .constant(false), maxHeight: 50.0)
                .environmentObject(viewModel)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }

    }
}

