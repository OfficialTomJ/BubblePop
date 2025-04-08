//
//  GameVew.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameState

    var body: some View {
        ZStack {
            VStack {
                Text("Player: \(game.playerName)")
                Text("Score: \(game.score)")
                Text("Time Left: \(game.timeRemaining)")
                    .font(.headline)
                    .padding(.bottom, 10)
            }
            .position(x: 100, y: 40)

            ForEach(game.bubbles) { bubble in
                Circle()
                    .fill(bubble.color.color)
                    .frame(width: 60, height: 60)
                    .position(bubble.position)
                    .onTapGesture {
                        game.popBubble(bubble)
                    }
            }
        }
        .onAppear {
            game.startGame()
        }
    }
}
