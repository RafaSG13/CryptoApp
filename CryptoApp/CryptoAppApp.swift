//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    @StateObject var viewModel = HomeViewModel(with: CoinDataSource())
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(viewModel)
        }
    }
}
