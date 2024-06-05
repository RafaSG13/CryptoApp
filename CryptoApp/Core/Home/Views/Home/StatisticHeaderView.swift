//
//  StatisticHeaderView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 31/5/24.
//

import SwiftUI

struct StatisticHeaderView: View {
    @EnvironmentObject private var coinVM: CoinViewModel
    @Binding var showPortfolio: Bool

    var body: some View {
        HStack {
            ForEach(coinVM.statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }.frame(width: UIScreen.main.bounds.width,
                alignment: showPortfolio ? .trailing : .leading)
    }
}

struct StatisticHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticHeaderView(showPortfolio: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)

            StatisticHeaderView(showPortfolio: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }

    }
}

