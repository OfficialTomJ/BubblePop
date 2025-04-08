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
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter your name:")
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                NavigationLink(destination: GameView()) {
                    Text("Start Game")
                }
                .simultaneousGesture(TapGesture().onEnded {
                    game.playerName = name
                    game.prepareGameStart()
                })
                .disabled(name.isEmpty)
                
                NavigationLink("View High Scores", destination: ScoreboardView())
                    .padding(.top)
                
                NavigationLink("Settings", destination: SettingsView())
                    .padding(.top)
            }
            .padding()
            .navigationTitle("BubblePop")
        }
    }
}
