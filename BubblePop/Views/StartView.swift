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
            VStack(spacing: 40) {
                Spacer()

                Image("bubble_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 240)
                    .padding(.horizontal, 30)

                VStack(spacing: 20) {
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal)

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
            .background(Color(hex: "#31aae1").ignoresSafeArea())
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines))
        scanner.currentIndex = hex.startIndex

        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    StartView()
        .environmentObject(GameState())
}
