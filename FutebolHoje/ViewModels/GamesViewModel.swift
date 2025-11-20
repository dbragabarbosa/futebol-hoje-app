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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let db = Firestore.firestore()
    
    init()
    {
        loadGames()
    }
    
    private func loadGames()
    {
        isLoading = true
        errorMessage = nil
        
        db.collection("games").addSnapshotListener
        { [weak self] snapshot, error in
            
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error
            {
                self.errorMessage = "Erro ao carregar jogos. Tente novamente."
                print("❌ Erro ao carregar jogos: \(error.localizedDescription)")
                return
            }

            do
            {
                let games = try snapshot?.documents.compactMap
                { doc in
                    
                    try doc.data(as: Game.self)
                } ?? []
                
                print("✅ Jogos carregados com sucesso: \(games.count)")
                games.forEach { print("🏟️ \($0.homeTeam ?? "Time A") x \($0.awayTeam ?? "Time B")") }
                print("\n")
                
                // Filtra apenas os jogos do dia atual
                let calendar = Calendar.current
                let today = Date()
                let filteredGames = games.filter
                { game in
                    
                    guard let date = game.date else { return false }
                    return calendar.isDate(date, inSameDayAs: today)
                }
                .sorted
                { lhs, rhs in
                    guard let leftDate = lhs.date else { return false }
                    guard let rightDate = rhs.date else { return true }
                    return leftDate < rightDate
                }
                
                self.todayGames = filteredGames
                
                print("📅 Jogos de hoje: \(self.todayGames.count)")
                self.todayGames.forEach { print("🏟️ \($0.homeTeam ?? "Time A") x \($0.awayTeam ?? "Time B")") }
                print("\n")
                
                // Limpa erro se carregou com sucesso
                self.errorMessage = nil
            }
            catch
            {
                self.errorMessage = "Erro ao processar dados dos jogos."
                print("❌ Erro ao decodificar jogos: \(error.localizedDescription)")
            }
        }
    }
    
    /// Função para recarregar os jogos manualmente
    func refreshGames()
    {
        loadGames()
    }
}
