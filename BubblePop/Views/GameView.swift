//
//  GameView.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameState

    var body: some View {
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
        }
        .onAppear {
            if !game.hasStarted && game.preGameCountdown == nil {
                game.prepareGameStart()
            }
        }
    }
}
