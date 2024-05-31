//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import SwiftUI

struct CoinRowView: View {
    private enum ViewConstants {
        static let symbolPadding: CGFloat = 6
    }
    let coin: Coin
    let showMarketInfoColumn: Bool
    @StateObject var viewModel: CircularImageViewModel

    var body: some View {
        HStack(spacing: 0) {
            currencyInfoColumn
            Spacer()
            if showMarketInfoColumn { currencyAmountInMarketColumn }
            currencyPriceInfo
        }
        .font(.subheadline)
    }
}

//TODO: ADD MOCK TO VIEWMODEL
//#Preview {
//    CoinRowView(coin: CoinPreviewMock.instance(), metadata: MetadataMock.instance(), showMarketInfoColumn: true)
//        .previewLayout(.sizeThatFits)
//}


extension CoinRowView {
    private var currencyInfoColumn: some View {
        HStack {
            Text("\(coin.cmcRank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryTextColor)
                .frame(minWidth: 30)
            if let image = viewModel.image {
                CircularImageView(coinLogo: image)
                    .frame(width: 30, height: 30)
            } else {
                Circle()
                    .frame(width: 30, height: 30)
            }
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accentColor)
                .frame(minWidth: 30)
                .padding(.leading, ViewConstants.symbolPadding)
        }.task {
            await viewModel.getImage(for: coin)
        }
    }

    private var currencyAmountInMarketColumn: some View {
        HStack {
            VStack(alignment: .trailing) {
                Text(coin.circulatingSupply.asNumberString())
                    .foregroundStyle(Color.theme.accentColor)
                    .font(.headline)
                Text((coin.circulatingSupply * (coin.quote["USD"]?.price ?? 0)).asCurrencyWith2Decimals())
                    .foregroundStyle(Color.theme.secondaryTextColor)
                    .font(.subheadline)
            }
        }
    }

    private var currencyPriceInfo: some View {
        VStack(alignment: .trailing) {
            Text(coin.quote["USD"]?.price.asCurrencyWith2Decimals() ?? "")
                .bold()
                .foregroundStyle(Color.theme.accentColor)
            Text(coin.quote["USD"]?.percentChange24h.asPercentageString() ?? "")
                .foregroundStyle((coin.quote["USD"]?.percentChange24h ?? 0) >= 0
                                 ? Color.theme.green
                                 : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
        .padding(.trailing, 6)
    }
}
