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
    static let launchTheme = LaunchColorTheme()
}


struct ColorTheme {
    let accentColor = Color("AccentColor")
    let backgroundColor = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryTextColor = Color("SecondaryTextColor")

}

struct LaunchColorTheme {
    let launchBackground = Color("LaunchBackgroundColor")
    let launchAccentColor = Color("LaunchAccentColor")
}
