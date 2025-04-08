//
//  Bubble.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI
import Foundation

enum BubbleColor: CaseIterable {
    case red, pink, green, blue, black

    var color: Color {
        switch self {
        case .red: return Color(red: 255/255, green: 115/255, blue: 115/255) // soft red
        case .pink: return Color(red: 255/255, green: 160/255, blue: 200/255) // pastel pink
        case .green: return Color(red: 144/255, green: 238/255, blue: 144/255) // light green
        case .blue: return Color(red: 135/255, green: 206/255, blue: 250/255) // sky blue
        case .black: return Color(red: 60/255, green: 60/255, blue: 60/255) // soft gray-black
        }
    }

    var points: Int {
        switch self {
        case .red: return 1
        case .pink: return 2
        case .green: return 5
        case .blue: return 8
        case .black: return 10
        }
    }

    static func randomWeighted() -> BubbleColor {
        let rand = Double.random(in: 0..<1)
        switch rand {
        case 0..<0.4: return .red
        case 0.4..<0.7: return .pink
        case 0.7..<0.85: return .green
        case 0.85..<0.95: return .blue
        default: return .black
        }
    }
}

class Bubble: Identifiable, ObservableObject {
    let id = UUID()
    let color: BubbleColor
    @Published var position: CGPoint
    let velocity: CGSize

    init(color: BubbleColor, position: CGPoint, velocity: CGSize = CGSize(width: Double.random(in: -1.5...1.5), height: Double.random(in: -1.5...1.5))) {
        self.color = color
        self.position = position
        self.velocity = velocity
    }
}
