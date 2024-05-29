//
//  ContentView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.backgroundColor
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Text("AccentColor")
                    .foregroundStyle(Color.theme.accentColor)
                Text("SecondaryTextColor")
                    .foregroundStyle(Color.theme.secondaryTextColor)
                Text("Red Color")
                    .foregroundStyle(Color.theme.red)
                Text("Green Color")
                    .foregroundStyle(Color.theme.green)
            }
            .font(.headline)
        }
    }
}

#Preview {
    ContentView()
}
