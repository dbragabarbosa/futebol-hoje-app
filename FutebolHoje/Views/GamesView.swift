//
//  GamesView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 08/08/25.
//

import Foundation
import SwiftUI
import Combine
import SwiftSoup

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
        fetchTransmissionInfo()
    }
    
    private func loadMockData()
    {
        games = [
            Game(homeTeam: "Galo", awayTeam: "Palmeiras", time: "16:00", channel: "Globo"),
            Game(homeTeam: "Corinthians", awayTeam: "São Paulo", time: "18:30", channel: "Premiere"),
            Game(homeTeam: "Grêmio", awayTeam: "Internacional", time: "20:00", channel: "YouTube")
        ]
    }
    
    func fetchTransmissionInfo()
    {
        guard let url = URL(string: "https://www.jogosdehojenatv.com.br") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Erro: \(error?.localizedDescription ?? "desconhecido")")
                return
            }
            
            do {
                let html = String(decoding: data, as: UTF8.self)
                let doc: Document = try SwiftSoup.parse(html)
                
                // Aqui você precisa inspecionar o HTML do GE para ver onde aparece a transmissão.
                // Exemplo genérico: buscar por elementos que contenham a palavra "Transmissão".
                let elements = try doc.getAllElements()
                for element in elements {
                    let text = try element.text()
                    if text.contains("Transmissão") || text.contains("Premiere") || text.contains("SporTV") || text.contains("Globo") {
                        print("➡️ \(text)")
                    }
                }
                
            } catch {
                print("Erro no parse: \(error)")
            }
        }
        task.resume()
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
