//
//  GameState.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI
import Combine

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
        let count = Int.random(in: 5...max)
        var newBubbles: [Bubble] = []

        for _ in 0..<count {
            let color = BubbleColor.randomWeighted()
            let position = CGPoint(x: Double.random(in: 50...300), y: Double.random(in: 100...600))
            newBubbles.append(Bubble(color: color, position: position))
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
