//
//  GameState.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI
import Combine
import SwiftData

class GameState: ObservableObject {
    @Published var bubbles: [Bubble] = []
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 60
    @Published var playerName: String = ""
    @Published var isGameRunning: Bool = false
    
    @Published var gameDuration: Int = 60
    @Published var maxBubbles: Int = 15

    private var timer: Timer?
    private var lastPoppedColor: BubbleColor?
    
    var modelContext: ModelContext?

    func startGame() {
            score = 0
            timeRemaining = gameDuration
            isGameRunning = true
            generateBubbles(max: maxBubbles)

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.tick()
            }
        }

    func stopGame() {
        timer?.invalidate()
        isGameRunning = false
        
        // Save high score
        if let context = modelContext {
            let entry = ScoreEntry(playerName: playerName, score: score)
            context.insert(entry)
            try? context.save()
        }
    }

    func tick() {
            if timeRemaining > 0 {
                timeRemaining -= 1
                generateBubbles(max: maxBubbles)
            } else {
                stopGame()
            }
        }

    func generateBubbles(max: Int = 15) {
        var newBubbles: [Bubble] = []
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let diameter: CGFloat = 60

        var attempts = 0

        while newBubbles.count < Int.random(in: 5...max) && attempts < 1000 {
            attempts += 1
            let x = CGFloat.random(in: diameter...(screenWidth - diameter))
            let y = CGFloat.random(in: 100...(screenHeight - diameter))
            let position = CGPoint(x: x, y: y)

            let newBubble = Bubble(color: BubbleColor.randomWeighted(), position: position)

            let overlaps = newBubbles.contains { existing in
                let dx = existing.position.x - newBubble.position.x
                let dy = existing.position.y - newBubble.position.y
                let distance = sqrt(dx * dx + dy * dy)
                return distance < diameter
            }

            if !overlaps {
                newBubbles.append(newBubble)
            }
        }

        self.bubbles = newBubbles
    }

    func popBubble(_ bubble: Bubble) {
        guard let index = bubbles.firstIndex(where: { $0.id == bubble.id }) else { return }

        var points = bubble.color.points
        if let last = lastPoppedColor, last == bubble.color {
            points = Int(Double(points) * 1.5.rounded())
        }
        score += points
        lastPoppedColor = bubble.color

        bubbles.remove(at: index)
    }
}
