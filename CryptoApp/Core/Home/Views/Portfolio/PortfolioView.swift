//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { saveButton }
                ToolbarItem(placement: .topBarLeading) { XmarkButton() }
            }
            .onChange(of: viewModel.searchText) {
                if viewModel.searchText == "" { removeSelectedCoin() }
            }
        }
    }
}

//MARK: View Components

extension PortfolioView {
    private var coinHorizontalList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.searchText.isEmpty ? viewModel.portfolioCoin : viewModel.allCoins) { coin in
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
                            updateSelectedCoin(coin: coin)
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

    private var saveButton: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button {
                savedButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
        }
    }
}

//MARK: Private functions

private extension PortfolioView {
    func savedButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(quantityText) else { return }
        viewModel.updatePortfolio(coin: coin, amount: amount)
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }

        UIApplication.shared.endEditing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }

    func removeSelectedCoin() {
        selectedCoin = nil
    }

    func getCurrentValue() -> Double {
        guard let quantity = Double(quantityText) else { return 0 }
        return quantity * (selectedCoin?.quote["USD"]?.price ?? 0)
    }

    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        if let portfolioCoin = viewModel.portfolioCoin.first(where: { $0.id == coin.id }) {
            if let amount = portfolioCoin.currentHolding{
                quantityText = String(amount)
            } else {
                quantityText = ""
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = CryptoRepository(coinDataSource: CoinDataSourceMock(),
                                    marketDataSource: MarketDataSourceMock(),
                                    portfolioDataSource: PortfolioDataSourceMock())
        let viewModel = HomeViewModel(with: repo)
        Group {
            PortfolioView()
                .environmentObject(viewModel)
        }

    }
}
