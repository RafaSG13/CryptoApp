//
//  View+NoAnimation.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 29/5/24.
//
import SwiftUI

extension View {
    func noAnimation() -> some View {
        self.transaction { transaction in
            transaction.animation = nil
        }
    }
}
