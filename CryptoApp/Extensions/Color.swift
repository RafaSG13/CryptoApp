//
//  Color.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}


struct ColorTheme {
    let accentColor = Color("AccentColor")
    let backgroundColor = Color("BackgroundColor")
    let green = Color("GreenThemeColor")
    let red = Color("RedThemeColor")
    let secondaryTextColor = Color("SecondaryTextColor")
}
