//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var viewModel: CoinViewModel
    @State private var selectedCoin: Coin? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)
                    coinHorizontalList
                    if selectedCoin != nil {
                        selectedCoinInfo
                    }
                }

            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Image(systemName: "checkmark")
                            .opacity(showCheckmark ? 1.0 : 0.0)
                        Button {
                            //NOTHING
                        } label: {
                            Text("Save".uppercased())
                        }
                     }
                }
                ToolbarItem(placement: .topBarLeading) { XmarkButton() }
            })
        }
    }
}

extension PortfolioView {
    private var coinHorizontalList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.allCoins) { coin in
                    VStack {
                        CircularImageView(coinLogo: viewModel.getCoinImage(for: coin.id))
                            .frame(width: 50)
                        Text(coin.symbol)
                            .font(.headline)
                            .foregroundStyle(Color.theme.accentColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Text(coin.name)
                            .font(.caption)
                            .foregroundStyle(Color.theme.secondaryTextColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedCoin?.id == coin.id ? Color.theme.accentColor : Color.clear, lineWidth: 1.5)
                            .fill(Color.theme.backgroundColor)
                            .frame(maxWidth: .infinity, maxHeight: 120)
                    )
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            selectedCoin = coin
                        }
                    }
                }
            }
            .padding(.leading)
        }
    }

    private var selectedCoinInfo: some View {
        VStack(spacing: 20) {
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.quote["USD"]?.price.asCurrencyWith2Decimals() ?? "")
            }

            Divider()
            HStack {
                Text("Amount holding: ")
                    .lineLimit(1)
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }

            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .noAnimation()
        .padding()
        .font(.headline)
    }

    private func getCurrentValue() -> Double {
        guard let quantity = Double(quantityText) else { return 0 }
        return quantity * (selectedCoin?.quote["USD"]?.price ?? 0)
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CoinViewModel(with: CoinDataSource(forPreview: true))
        Group {
            PortfolioView()
                .environmentObject(viewModel)
        }

    }
}