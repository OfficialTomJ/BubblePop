//
//  ContentView.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var game = GameState()

    var body: some View {
        Group {
            if game.isGameRunning {
                GameView()
            } else {
                StartView()
            }
        }
        .environmentObject(game)
    }
}
