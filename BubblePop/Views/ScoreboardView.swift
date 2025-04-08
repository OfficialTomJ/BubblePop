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
        List {
            ForEach(scores.prefix(10)) { entry in
                HStack {
                    Text(entry.playerName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(entry.score)")
                        .frame(alignment: .trailing)
                }
            }
        }
        .navigationTitle("High Scores")
    }
}
