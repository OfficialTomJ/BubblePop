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
        case .red: return .red
        case .pink: return .pink
        case .green: return .green
        case .blue: return .blue
        case .black: return .black
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
