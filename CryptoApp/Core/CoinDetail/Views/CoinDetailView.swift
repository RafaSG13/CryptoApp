//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 4/6/24.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?

    var body: some View {
        ZStack {
            if let coin = coin {
                CoinDetailView(coin: coin)
            }
        }
    }
}

struct CoinDetailView: View {
    let coin: Coin

    var body: some View {
        ZStack {
            Text(coin.name)
        }
    }
}

#Preview {
    CoinDetailView(coin:CoinPreviewMock.instance())
}
