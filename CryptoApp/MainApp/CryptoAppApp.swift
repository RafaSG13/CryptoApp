//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    @StateObject var viewModel = HomeViewModel(with: CryptoRepository(coinDataSource: CoinDataSource(),
                                                                      marketDataSource: MarketDataSource(),
                                                                      portfolioDataSource: PortfolioDataSource()))
    @State private var showLaunchView: Bool = true
    @State private var viewModelLoaded: Bool = false

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
                LaunchView()
                    .opacity(showLaunchView ? 1 : 0)
                    .animation(.easeOut(duration: 0.5))
            }
            .zIndex(2.0)
            .task(priority: .high) {
                do {
                    try await viewModel.setViewModel()
                    withAnimation { showLaunchView.toggle() }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
