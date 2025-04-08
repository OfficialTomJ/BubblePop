//
//  SettingsView.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var game: GameState

    var body: some View {
        Form {
            Section(header: Text("Game Time")) {
                Stepper(value: $game.gameDuration, in: 10...180, step: 10) {
                    Text("\(game.gameDuration) seconds")
                }
            }

            Section(header: Text("Max Bubbles")) {
                Stepper(value: $game.maxBubbles, in: 5...30) {
                    Text("\(game.maxBubbles) bubbles")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
