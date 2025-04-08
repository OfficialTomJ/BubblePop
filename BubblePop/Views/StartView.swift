//
//  StartView.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var game: GameState
    @State private var name = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter your name:")
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Start Game") {
                game.playerName = name
                game.startGame()
            }
            .disabled(name.isEmpty)
        }
        .padding()
    }
}
