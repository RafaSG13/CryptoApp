//
//  ChartView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 13/6/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @State var data: [CoinChartData]
    @State var lineColor = Color.clear

    var body: some View {
        Chart {
            ForEach(data) { datum in
                LineMark(x: .value("Days ago", datum.daysAgo),
                         y: .value("Percentage Change", datum.value))
                .foregroundStyle(lineColor)
                .shadow(color: lineColor, radius: 5, y: 0)
                .shadow(color: lineColor, radius: 5, y: 0)

            }
        }.padding(.vertical)
            .onAppear {
                getRange()
            }
    }

    private func getRange() {
        guard !data.isEmpty else { return }
        if let lastValue = data.last?.value {
            lineColor = lastValue >= 0 ? Color.theme.green : Color.theme.red
        }
    }
}

#Preview {
    ChartView(data: [CoinChartData(id: .init(), daysAgo: 1, value: 123),
                     CoinChartData(id: .init(), daysAgo: 15, value: 1213),
                     CoinChartData(id: .init(), daysAgo: 30, value: 983),
                     CoinChartData(id: .init(), daysAgo: 60, value: 557),
                     CoinChartData(id: .init(), daysAgo: 90, value: 873)])
}
