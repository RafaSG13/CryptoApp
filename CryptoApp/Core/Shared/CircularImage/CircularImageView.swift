//
//  CircularImageView.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 30/5/24.
//

import SwiftUI

struct CircularImageView: View {
    @State var coinLogo: UIImage?
    var body: some View {
        ZStack {
            if let image = coinLogo {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryTextColor)
            }
        }
    }
}

#Preview {
    CircularImageView(coinLogo: UIImage(systemName: "house.fill")!)
}
