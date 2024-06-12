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

    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = true
    @State private var showPortfolioView: Bool = false

    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView = false

    var body: some View {
        ZStack {
            Color.theme.backgroundColor
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(viewModel)
                })
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
        .navigationDestination(isPresented: $showDetailView,destination: {
            DetailLoadingView(coin: $selectedCoin, repository: viewModel.repository)
        })
    }
}

extension HomeView {
    private var homeHeaderView: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .noAnimation()
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
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
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
    }

    private var portfolioList: some View  {
        List {
            ForEach(viewModel.portfolioCoin) { coin in
                CoinRowView(coin: coin,
                            showMarketInfoColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
    }

    private var columnsHeader: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0.00 : 180))
            }.onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }

            Spacer()
            if showPortfolio {
                Text("Market Info")
            }

            HStack(spacing: 4) {
                Text("Prices")
                    .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption == .price || viewModel.sortOption == .priceReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0.00 : 180))
            }.onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                }
            }

            Button {
                withAnimation(.linear(duration: 2)) {
                    viewModel.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
                    .rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryTextColor)
        .padding(.horizontal)
    }
}


private extension HomeView {
    func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = CryptoRepository(coinDataSource: CoinDataSource(), marketDataSource: MarketDataSource())
        let viewModel = HomeViewModel(with: repo)
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
