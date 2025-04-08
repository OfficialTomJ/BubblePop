//
//  GameView.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI
import ConfettiSwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameState
    @State private var confettiCounter = 0

    var body: some View {
        VStack {
            ZStack {
                // Game UI
                VStack {
                    Text("Player: \(game.playerName)")
                    Text("Score: \(game.score)")
                    Text("Highest Score: \(game.highestScore)")
                        .foregroundColor(game.score >= game.highestScore ? .green : .gray)
                    Text("Time Left: \(game.timeRemaining)")
                        .font(.headline)
                        .padding(.bottom, 10)
                }
                .position(x: 100, y: 40)

                // Bubbles (only show if countdown is nil)
                if game.preGameCountdown == nil {
                    ForEach(game.bubbles) { bubble in
                        Circle()
                            .fill(bubble.color.color)
                            .frame(width: 60, height: 60)
                            .position(bubble.position)
                            .animation(.linear(duration: 1.0 / 60.0), value: bubble.position)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    game.popBubble(bubble)
                                }
                            }
                    }
                }

                // Countdown Overlay
                if let countdown = game.preGameCountdown {
                    ZStack {
                        Color.black.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)

                        Text(countdown == 0 ? "Go!" : "\(countdown)")
                            .font(.system(size: countdown == 0 ? 64 : 72, weight: .bold))
                            .foregroundColor(.white)
                            .scaleEffect(countdown == 0 ? 1.4 : 1.2)
                            .transition(.scale)
                            .animation(.easeInOut, value: countdown)
                    }
                    .zIndex(1)
                }

                // Game Over Screen
                if game.isGameOver {
                    ZStack {
                        Color.black.opacity(0.8)
                            .edgesIgnoringSafeArea(.all)

                        VStack(spacing: 20) {
                            Text("Game Over")
                                .font(.largeTitle)
                                .foregroundColor(.white)

                            if game.isNewHighScore {
                                Text("🎉 New High Score!")
                                    .font(.title2)
                                    .foregroundColor(.yellow)
                            }

                            Text("Your Score: \(game.score)")
                                .font(.title)
                                .foregroundColor(.white)

                            Button(action: {
                                game.resetGame()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    game.prepareGameStart()
                                }
                            }) {
                                Text("Play Again")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            }

                            Button(action: {
                                game.resetGame()
                                game.isInGame = false
                            }) {
                                Text("Back to Menu")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .zIndex(2)
                }
            }
        }
        .onAppear {
            if !game.hasStarted && game.preGameCountdown == nil && !game.isGameOver {
                game.prepareGameStart()
            }
        }
    }
}
