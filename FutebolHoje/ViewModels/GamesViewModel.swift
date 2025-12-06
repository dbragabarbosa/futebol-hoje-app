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
    @Published var filterRegions: Set<String> = ["Brasil"]
    
    private let db = Firestore.firestore()
    private var allGames: [Game] = []
    
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
                self.allGames = try snapshot?.documents.compactMap
                { doc in
                    try doc.data(as: Game.self)
                } ?? []
                
                print("✅ Jogos carregados com sucesso: \(self.allGames.count)")
                self.applyFilters()
            }
            catch
            {
                self.errorMessage = "Erro ao processar dados dos jogos."
                print("❌ Erro ao decodificar jogos: \(error.localizedDescription)")
            }
        }
    }
    
    func updateFilter(regions: Set<String>)
    {
        self.filterRegions = regions
        applyFilters()
    }
    
    private func applyFilters()
    {
        let calendar = Calendar.current
        let today = Date()
        
        let filteredGames = allGames.filter
        { game in
            
            guard let date = game.date else { return false }
            guard calendar.isDate(date, inSameDayAs: today) else { return false }
            
            if filterRegions.isEmpty { return false }
            
            let normalizedRegion = determineRegion(for: game)
            return filterRegions.contains(normalizedRegion)
        }
        .sorted
        { lhs, rhs in
            guard let leftDate = lhs.date else { return false }
            guard let rightDate = rhs.date else { return true }
            return leftDate < rightDate
        }
        
        self.todayGames = filteredGames
        self.errorMessage = nil
    }
    
    private func determineRegion(for game: Game) -> String
    {
        let europeanCompetitions = [
            "UEFA Champions League",
            "UEFA Europa League",
            "UEFA Conference League",
            "Campeonato Alemão",
            "Campeonato Espanhol",
            "Campeonato Francês",
            "Campeonato Inglês",
            "Campeonato Italiano",
            "Campeonato Português",
            "Copa da Inglaterra",
            "Copa da Liga Inglesa",
            "Copa do Rei",
            "Copa da Itália",
            "Copa da Alemanha",
            "Copa da França",
            "Taça de Portugal"
        ]
        
        let competition = game.competition ?? ""
        
        if europeanCompetitions.contains(where: { competition.contains($0) })
        {
            return "Europa"
        }
        
        let region = game.region ?? "Brasil"
        if region == "UE" || region == "Europa"
        {
            return "Europa"
        }
        
        return "Brasil"
    }
    
    func refreshGames()
    {
        loadGames()
    }
}
