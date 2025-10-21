//
//  GamesViewModel.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 05/08/25.
//

import Foundation
import Combine
import Firebase
import FirebaseCore
import FirebaseAI
import FirebaseFirestore

@MainActor
class GamesViewModel: ObservableObject
{
    @Published var games: [Game] = []
    @Published var todayGames: [Game] = []
    
    private let db = Firestore.firestore()
    
    init()
    {
        loadGames()
    }
    
    private func loadGames()
    {
        db.collection("games").addSnapshotListener
        { snapshot, error in
            
            if let error = error
            {
                print("Erro ao carregar jogos: \(error.localizedDescription)")
                return
            }

            do
            {
                let games = try snapshot?.documents.compactMap
                { doc in
                    
                    try doc.data(as: Game.self)
                } ?? []
                
                print("✅ Jogos carregados com sucesso: \(games.count)")
                games.forEach { print("🏟️ \($0.homeTeam) x \($0.awayTeam) em \($0.date)") }
                print("\n")
                
                // Filtra apenas os jogos do dia atual
                let calendar = Calendar.current
                let today = Date()
                self.todayGames = games.filter
                { game in
                    
                    guard let date = game.date else { return false }
                    return calendar.isDate(date, inSameDayAs: today)
                }
                
                print("📅 Jogos de hoje: \(self.todayGames.count)")
                self.todayGames.forEach { print("🏟️ \($0.homeTeam) x \($0.awayTeam) em \($0.date)") }
                print("\n")
            }
            catch
            {
                print("Erro ao decodificar jogos: \(error.localizedDescription)")
            }
        }
    }
}
