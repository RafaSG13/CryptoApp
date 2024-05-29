//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accentColor)
            .frame(width: 50, height: 50, alignment: .center)
            .background(Circle()
                .foregroundStyle(Color.theme.backgroundColor)
            )
            .shadow(color: Color.theme.accentColor.opacity(0.25), radius: 10, x: 0, y: 0)
            .padding()

    }
}

#Preview {
    CircleButtonView(iconName: "heart.fill")
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
}
