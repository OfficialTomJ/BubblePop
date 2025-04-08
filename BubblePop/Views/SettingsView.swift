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
        VStack {
            Text("⚙️ Game Settings")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 20)

            Form {
                Section(header: Text("Game Time").foregroundColor(.white)) {
                    Stepper(value: $game.gameDuration, in: 10...180, step: 10) {
                        Text("\(game.gameDuration) seconds")
                            .foregroundColor(.black)
                    }
                }

                Section(header: Text("Max Bubbles").foregroundColor(.white)) {
                    Stepper(value: $game.maxBubbles, in: 5...30) {
                        Text("\(game.maxBubbles) bubbles")
                            .foregroundColor(.black)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .background(Color(red: 49/255, green: 170/255, blue: 225/255).ignoresSafeArea())
    }
}

#Preview {
    NavigationView {
        SettingsView().environmentObject(GameState())
    }
}
