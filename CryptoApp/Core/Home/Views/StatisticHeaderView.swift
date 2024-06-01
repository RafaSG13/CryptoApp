//
//  StatisticHeaderView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 31/5/24.
//

import SwiftUI

struct StatisticHeaderView: View {
 
    @EnvironmentObject private var viewModel: CoinViewModel
    @Binding var showPortfolio: Bool

    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }.frame(width: UIScreen.main.bounds.width,
                alignment: showPortfolio ? .trailing : .leading)
    }
}

struct StatisticHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CoinViewModel(with: CoinDataSource(forPreview: true))
        Group {
            StatisticHeaderView(showPortfolio: .constant(true))
                .environmentObject(viewModel)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)

            StatisticHeaderView(showPortfolio: .constant(true))
                .environmentObject(viewModel)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }

    }
}

