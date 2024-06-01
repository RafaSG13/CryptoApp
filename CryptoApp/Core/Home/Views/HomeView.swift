//
//  HomeView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import SwiftUI

struct HomeView: View {
    private enum ViewConstants {
        static let rotationDegrees: Double = 180
    }

    @EnvironmentObject private var viewModel: CoinViewModel
    @State private var showPortfolio: Bool = true

    var body: some View {
        ZStack {
            Color.theme.backgroundColor
                .ignoresSafeArea()
            VStack {
                homeHeaderView
                StatisticHeaderView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $viewModel.searchText)
                columnsHeader
                if !showPortfolio {
                    coinsList
                        .transition(.move(edge: .leading))
                } else {
                    portfolioList
                        .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
        }
    }
}

extension HomeView {
    private var homeHeaderView: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .noAnimation()
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio": "Live Prices")
                .animation(.none)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.accentColor)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? ViewConstants.rotationDegrees : .zero))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }


    private var coinsList: some View  {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin,
                            showMarketInfoColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }

    private var portfolioList: some View  {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin,
                            showMarketInfoColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }

    private var columnsHeader: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Market Info")
            }
            Text("Prices")
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryTextColor)
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CoinViewModel(with: CoinDataSource(forPreview: true))
        Group {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
                    .environmentObject(viewModel)
                    .preferredColorScheme(.light)
            }
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
                    .environmentObject(viewModel)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
