//
//  ScoreEntry.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import Foundation
import SwiftData

@Model
class ScoreEntry {
    var playerName: String
    var score: Int
    var timestamp: Date

    init(playerName: String, score: Int, timestamp: Date = .now) {
        self.playerName = playerName
        self.score = score
        self.timestamp = timestamp
    }
}
