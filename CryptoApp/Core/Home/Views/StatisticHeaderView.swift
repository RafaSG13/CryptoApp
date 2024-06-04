//
//  StatisticHeaderView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 31/5/24.
//

import SwiftUI

struct StatisticHeaderView: View {
    @StateObject private var marketVM: MarketInfoViewModel
    @Binding var showPortfolio: Bool

    init(showPortfolio: Binding<Bool>,
         marketVM: MarketInfoViewModel = MarketInfoViewModel(marketDataSource: MarketDataSource())) {
        self._showPortfolio = showPortfolio
        self._marketVM = StateObject(wrappedValue: marketVM)
    }

    var body: some View {
        HStack {
            ForEach(marketVM.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }.frame(width: UIScreen.main.bounds.width,
                alignment: showPortfolio ? .trailing : .leading)
    }
}

struct StatisticHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MarketInfoViewModel(marketDataSource: MarketDataSource(forPreview: true))
        Group {
            StatisticHeaderView(showPortfolio: .constant(false), marketVM: viewModel)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)

            StatisticHeaderView(showPortfolio: .constant(false), marketVM: viewModel)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }

    }
}

