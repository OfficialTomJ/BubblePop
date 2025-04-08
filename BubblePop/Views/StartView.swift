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
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()

                Image("bubble_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 160)
                    .padding(.horizontal, 30)

                VStack(spacing: 20) {
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .accessibilityIdentifier("nameTextField")

                    NavigationLink(destination: GameView(), isActive: $game.isInGame) {
                        EmptyView()
                    }

                    Button(action: {
                        game.playerName = name
                        game.prepareGameStart()
                    }) {
                        Text("Start Game")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .disabled(name.isEmpty)
                    .accessibilityIdentifier("startGameButton")

                    NavigationLink("View High Scores", destination: ScoreboardView())
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    NavigationLink("Settings", destination: SettingsView())
                        .font(.subheadline)
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .background(Color(red: 49/255, green: 170/255, blue: 225/255).ignoresSafeArea())
        }
    }
}

#Preview {
    StartView()
        .environmentObject(GameState())
}
