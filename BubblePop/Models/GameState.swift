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
    @Published var highestScore: Int = 0
    @Published var timeRemaining: Int = 60
    @Published var playerName: String = ""
    @Published var isGameRunning: Bool = false
    @Published var isGameOver: Bool = false
    
    @Published var gameDuration: Int = 60
    @Published var maxBubbles: Int = 15
    @Published var isInGame: Bool = false
    @Published var showConfetti: Bool = false
    @Published var isNewHighScore: Bool = false

    private var timer: Timer?
    private var lastPoppedColor: BubbleColor?
    
    var modelContext: ModelContext?
    
    private var animationCancellable: AnyCancellable?
    
    @Published var preGameCountdown: Int? = nil
    @Published var hasStarted: Bool = false

    func prepareGameStart() {
        guard !hasStarted else { return }
        isInGame = true
        preGameCountdown = 3
        var count = 3

        SoundManager.shared.playSound(named: "3")

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            count -= 1
            if count > 0 {
                self.preGameCountdown = count
                SoundManager.shared.playSound(named: "\(count)")
            } else {
                self.preGameCountdown = nil
                SoundManager.shared.playSound(named: "start")
                self.hasStarted = true
                self.startGame()
                timer.invalidate()
            }
        }
    }

    func startGame() {
            score = 0
            timeRemaining = gameDuration
            isGameRunning = true
            isGameOver = false
            generateBubbles(max: maxBubbles)
        
            fetchHighestScore()

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.tick()
            }
        
            // Animation timer (runs ~60fps)
            animationCancellable = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    self.updateBubblePositions()
                }
        }
    
    func fetchHighestScore() {
        guard let context = modelContext else { return }

        do {
            // Get all scores and sort manually
            let allScores = try context.fetch(FetchDescriptor<ScoreEntry>())
            let top = allScores.sorted { $0.score > $1.score }.first
            self.highestScore = top?.score ?? 0
        } catch {
            print("Failed to fetch scores: \(error)")
        }
    }

    func stopGame() {
        guard isGameRunning else { return }
        timer?.invalidate()
        animationCancellable?.cancel()
        isGameRunning = false
        isGameOver = true
        showConfetti = false

        // Save or update high score
        if let context = modelContext {
            do {
                let currentName = playerName
                let descriptor = FetchDescriptor<ScoreEntry>(
                    predicate: #Predicate { $0.playerName == currentName }
                )
                let existingScores = try context.fetch(descriptor)

                if let existing = existingScores.first {
                    if score > existing.score {
                        existing.score = score
                        try? context.save()
                        SoundManager.shared.playSound(named: "cheer")
                        self.showConfetti = true
                        self.isNewHighScore = true
                    }
                } else {
                    let entry = ScoreEntry(playerName: playerName, score: score)
                    context.insert(entry)
                    try? context.save()
                    SoundManager.shared.playSound(named: "cheer")
                    self.showConfetti = true
                    self.isNewHighScore = true
                }
            } catch {
                print("Failed to fetch or update score: \(error)")
            }
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
    
    func updateBubblePositions() {
            for bubble in bubbles {
                let speedMultiplier = 1.0 + (60.0 - Double(timeRemaining)) / 60.0
                let newX = bubble.position.x + bubble.velocity.width * speedMultiplier
                let newY = bubble.position.y + bubble.velocity.height * speedMultiplier
                bubble.position = CGPoint(x: newX, y: newY)
            }

            // Remove offscreen bubbles
            bubbles.removeAll {
                $0.position.x < -30 || $0.position.x > UIScreen.main.bounds.width + 30 ||
                $0.position.y < -30 || $0.position.y > UIScreen.main.bounds.height + 30
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

            let bubble = Bubble(color: BubbleColor.randomWeighted(), position: position)

            let overlaps = newBubbles.contains { existing in
                let dx = existing.position.x - bubble.position.x
                let dy = existing.position.y - bubble.position.y
                let distance = sqrt(dx * dx + dy * dy)
                return distance < diameter
            }

            if !overlaps {
                newBubbles.append(bubble)
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
        
        SoundManager.shared.playSound(named: "pop")
    }

    func resetGame() {
        timer?.invalidate()
        animationCancellable?.cancel()
        
        isGameRunning = false
        isGameOver = false
        hasStarted = false
        score = 0
        timeRemaining = gameDuration
        bubbles = []
        lastPoppedColor = nil
        preGameCountdown = nil
        showConfetti = false
        isNewHighScore = false
    }
}
