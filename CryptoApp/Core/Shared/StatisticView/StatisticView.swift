//
//  StatisticView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 31/5/24.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic
    var body: some View {
        VStack(alignment: .leading) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryTextColor)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accentColor)
            HStack {
                if let percentage = stat.percentageChange {
                    Image(systemName: "triangle.fill")
                        .font(.caption2)
                        .rotationEffect(Angle(degrees: percentage >= 0
                                              ? 0
                                              : 180))
                }
                Text(stat.percentageChange?.asPercentageString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((stat.percentageChange ?? 0) >= 0
                             ? Color.theme.green
                             : Color.theme.red)
        }
    }
}

#Preview {
    StatisticView(stat: StatisticMock.sampleStatistic)
}
