//
//  GamesView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 08/08/25.
//

import Foundation
import SwiftUI
import Combine

struct Game: Identifiable
{
    let id = UUID()
    let homeTeam: String
    let awayTeam: String
    let time: String
    let channel: String
}

class GamesViewModel: ObservableObject
{
    @Published var games: [Game] = []
    
    init()
    {
        loadMockData()
    }
    
    private func loadMockData()
    {
        games = [
            Game(homeTeam: "Galo", awayTeam: "Palmeiras", time: "16:00", channel: "Globo"),
            Game(homeTeam: "Corinthians", awayTeam: "São Paulo", time: "18:30", channel: "Premiere"),
            Game(homeTeam: "Grêmio", awayTeam: "Internacional", time: "20:00", channel: "YouTube")
        ]
    }
}

struct GamesView: View
{
    @StateObject private var viewModel = GamesViewModel()
    
    var body: some View
    {
        NavigationStack
        {
            List(viewModel.games)
            { game in
                
                VStack(alignment: .leading, spacing: 4)
                {
                    Text("\(game.homeTeam) x \(game.awayTeam)")
                        .font(.headline)
                    
                    Text("Horário: \(game.time)")
                        .font(.subheadline)
                    
                    Text("Transmissão: \(game.channel)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Jogos de Hoje")
        }
    }
}

#Preview
{
    GamesView()
}
