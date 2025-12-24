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
    @Published var selectedCompetitions: Set<String> = []
    @Published var isAllCompetitionsSelected: Bool = true
    @Published var isConnected: Bool = true
    
    private let db = Firestore.firestore()
    private let networkMonitor = NetworkMonitor()
    private var allGames: [Game] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init()
    {
        setupNetworkMonitoring()
        loadGames()
    }
    
    private func setupNetworkMonitoring()
    {
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                self?.isConnected = connected
            }
            .store(in: &cancellables)
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
        
        // Check if selected competitions are still available with new region filter
        if !isAllCompetitionsSelected
        {
            let currentAvailableCompetitions = Set(availableCompetitions)
            let selectedStillAvailable = selectedCompetitions.filter { currentAvailableCompetitions.contains($0) }
            
            // If none of the selected competitions are available anymore, reset to "All"
            if selectedStillAvailable.isEmpty
            {
                isAllCompetitionsSelected = true
                selectedCompetitions = []
            }
            else
            {
                // Keep only the competitions that are still available
                selectedCompetitions = selectedStillAvailable
            }
        }
        
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
            guard filterRegions.contains(normalizedRegion) else { return false }
            
            // Competition filter
            if !isAllCompetitionsSelected
            {
                guard let competition = game.competition else { return false }
                guard selectedCompetitions.contains(competition) else { return false }
            }
            
            return true
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
    
    var availableCompetitions: [String]
    {
        let calendar = Calendar.current
        let today = Date()
        
        let competitionsSet = Set(
            allGames
                .filter { game in
                    guard let date = game.date else { return false }
                    guard calendar.isDate(date, inSameDayAs: today) else { return false }
                    
                    if filterRegions.isEmpty { return false }
                    
                    let normalizedRegion = determineRegion(for: game)
                    return filterRegions.contains(normalizedRegion)
                }
                .compactMap { $0.competition }
        )
        
        return competitionsSet.sorted()
    }
    
    func toggleCompetition(_ competition: String)
    {
        if isAllCompetitionsSelected
        {
            isAllCompetitionsSelected = false
            selectedCompetitions = [competition]
        }
        else
        {
            if selectedCompetitions.contains(competition)
            {
                selectedCompetitions.remove(competition)
                
                if selectedCompetitions.isEmpty
                {
                    isAllCompetitionsSelected = true
                }
            }
            else
            {
                selectedCompetitions.insert(competition)
            }
        }
        
        applyFilters()
    }
    
    func selectAllCompetitions()
    {
        isAllCompetitionsSelected = true
        selectedCompetitions = []
        applyFilters()
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
