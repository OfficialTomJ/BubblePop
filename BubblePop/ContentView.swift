//
//  ContentView.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var game = GameState()
    @Environment(\.modelContext) var modelContext

    var body: some View {
        Group {
            if game.isGameRunning {
                GameView()
            } else {
                StartView()
            }
        }
        .onAppear {
            game.modelContext = modelContext
        }
        .environmentObject(game)
    }
}
