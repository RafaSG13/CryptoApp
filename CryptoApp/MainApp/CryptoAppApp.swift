//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    @StateObject var viewModel = HomeViewModel(with: CryptoRepository(coinDataSource: CoinDataSource(), marketDataSource: MarketDataSource()))
    @State private var showLaunchView: Bool = false

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .environmentObject(viewModel)
                if showLaunchView {
                    LaunchView(showHomeScreen: $showLaunchView)
                        .transition(.move(edge: .leading))
                }
            }
            .zIndex(2.0)
            .task(priority: .high) {
                do {
                    try await viewModel.getCoinInfo()
                    try await viewModel.getMarketInfo()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
