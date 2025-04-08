//
//  GameView.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI
import ConfettiSwiftUI
import _SwiftData_SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameState
    @State private var confettiCounter = 0
    @State private var poppedBubbleID: UUID?
    @Query(sort: \ScoreEntry.score, order: .reverse) var scores: [ScoreEntry]

    var body: some View {
        ZStack {
            Color(red: 49/255, green: 170/255, blue: 225/255)
                .ignoresSafeArea()
 
            // Bubbles (only show if countdown is nil)
            if game.preGameCountdown == nil {
                ForEach(game.bubbles) { bubble in
                    Circle()
                        .fill(bubble.color.color)
                        .frame(width: 60, height: 60)
                        .scaleEffect(poppedBubbleID == bubble.id ? 0.1 : 1.0)
                        .position(bubble.position)
                        .animation(.easeInOut(duration: 0.2), value: poppedBubbleID)
                        .onTapGesture {
                            poppedBubbleID = bubble.id
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                game.popBubble(bubble)
                                poppedBubbleID = nil
                            }
                        }
                }
            }

            // HUD
            if game.preGameCountdown == nil && !game.isGameOver {
                VStack {
                    VStack(alignment: .center, spacing: 6) {
                        Text("Player: \(game.playerName)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .shadow(radius: 1)

                        Text("Score: \(game.score)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 1)

                        Text("Highest Score: \(game.highestScore)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(game.score >= game.highestScore ? .yellow : .white.opacity(0.6))
                            .shadow(radius: 1)

                        Text("Time Left: \(game.timeRemaining)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                            .padding(.top, 4)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                    .padding(.top, 40)

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }

            // Countdown Overlay
            if let countdown = game.preGameCountdown {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()

                    VStack {
                        Spacer()
                        Text(countdown == 0 ? "Go!" : "\(countdown)")
                            .font(.system(size: countdown == 0 ? 64 : 72, weight: .bold))
                            .foregroundColor(.white)
                            .scaleEffect(countdown == 0 ? 1.4 : 1.2)
                            .transition(.scale)
                            .animation(.easeInOut, value: countdown)
                        Spacer()
                    }
                }
                .zIndex(3)
            }

            // Game Over Screen
            if game.isGameOver {
                ZStack {
                    Color.black.opacity(0.85)
                        .ignoresSafeArea()

                    VStack(spacing: 25) {
                        Text("Game Over")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)

                        if game.isNewHighScore {
                            Text("🎉 New High Score!")
                                .font(.title2)
                                .foregroundColor(.yellow)
                        }

                        Text("Your Score: \(game.score)")
                            .font(.title)
                            .foregroundColor(.white)

                        Text("Top Scores")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 10)

                        ForEach(scores.prefix(5)) { entry in
                            HStack {
                                Text(entry.playerName)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(entry.score)")
                                    .foregroundColor(.yellow)
                            }
                            .padding(.horizontal, 40)
                        }

                        Button(action: {
                            game.resetGame()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                game.prepareGameStart()
                            }
                        }) {
                            Text("Play Again")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                                .padding(.horizontal, 40)
                        }

                        Button(action: {
                            game.resetGame()
                            game.isInGame = false
                        }) {
                            Text("Back to Menu")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .padding(.horizontal, 40)
                        }
                    }
                    .padding()
                }
                .zIndex(2)
            }
        }
        .onAppear {
            if !game.hasStarted && game.preGameCountdown == nil && !game.isGameOver {
                game.prepareGameStart()
            }
        }
    }
}

#Preview {
    GameView()
        .environmentObject(GameState())
}
