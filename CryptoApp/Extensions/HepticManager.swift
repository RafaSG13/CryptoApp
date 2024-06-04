//
//  HepticManager.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 4/6/24.
//

import Foundation
import SwiftUI


class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }

}
