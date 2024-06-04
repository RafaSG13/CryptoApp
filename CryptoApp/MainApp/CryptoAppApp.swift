//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    @StateObject var viewModel = CoinViewModel(with: CoinDataSource())
    @State private var showLaunchView: Bool = false

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
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
        }
    }
}
