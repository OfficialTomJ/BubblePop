//
//  ScoreboardView.swift
//  BubblePop
//
//  Created by Tom on 8/4/2025.
//

import SwiftUI
import SwiftData

struct ScoreboardView: View {
    @Query(sort: \ScoreEntry.score, order: .reverse) var scores: [ScoreEntry]

    var body: some View {
        VStack {
            Text("🏆 High Scores")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 20)

            List {
                ForEach(scores.prefix(10)) { entry in
                    HStack {
                        Text(entry.playerName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(entry.score)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.yellow)
                            .frame(alignment: .trailing)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
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
        ScoreboardView()
    }
}
