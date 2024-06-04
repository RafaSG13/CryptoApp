//
//  LaunchView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 1/6/24.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText: [String] = "Loading crypto...".map { String($0) }
    @State private var showLoading: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loop: Int = 0
    @Binding var showHomeScreen: Bool

    var body: some View {
        ZStack {
            Color.launchTheme.launchBackground
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 150, height: 150)

            ZStack {
                if showLoading {
                    HStack(spacing: 0) {
                        ForEach(0..<loadingText.count, id: \.self) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundStyle(Color.launchTheme.launchAccentColor)
                                .transition(AnyTransition.scale.animation(.easeIn))
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                }

            }.offset(y: 100)

        }.onAppear {
            showLoading.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loop += 1
                    if loop >= 2 {
                        showHomeScreen = true
                    }
                } else {
                    counter += 1
                }
            }
        })
    }
}

#Preview {
    LaunchView(showHomeScreen: .constant(false))
}
