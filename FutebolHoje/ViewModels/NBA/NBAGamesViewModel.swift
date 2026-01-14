//
//  NBAGamesViewModel.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 27/12/25.
//

import Foundation
import Combine
import Firebase
import FirebaseCore
import FirebaseAI
import FirebaseFirestore

@MainActor
class NBAGamesViewModel: ObservableObject
{
    @Published var games: [Game] = []
    @Published var displayedGames: [Game] = []
    @Published var selectedDate: Date = Date()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isConnected: Bool = true
    @Published var allGames: [Game] = []
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let db = Firestore.firestore()
    private let networkMonitor = NetworkMonitor()
    
    init()
    {
        setupNetworkMonitoring()
        setupPipeline()
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
    
    private func setupPipeline()
    {
        refreshToday()
        refreshTodayWhenDayChanges()
    }
    
    private func refreshToday()
    {
        Publishers.CombineLatest3($allGames, $selectedDate, $searchText)
            .receive(on: DispatchQueue.main)
            .map { [weak self] (games, date, searchText) -> [Game] in
                guard let self = self else { return [] }
                return self.filterGames(games, date: date, searchText: searchText)
            }
            .assign(to: &$displayedGames)
    }
    
    private func refreshTodayWhenDayChanges()
    {
        NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if Calendar.current.isDateInToday(self.selectedDate) {
                    self.selectedDate = Date()
                }
            }
            .store(in: &cancellables)
    }
            
    private func loadGames()
    {
        isLoading = true
        errorMessage = nil
        
        db.collection("games_NBA").addSnapshotListener
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
            }
            catch
            {
                self.errorMessage = "Erro ao processar dados dos jogos."
                print("❌ Erro ao decodificar jogos: \(error.localizedDescription)")
            }
        }
    }
    
    private func filterGames(_ games: [Game], date targetDate: Date, searchText: String) -> [Game]
    {
        let calendar = Calendar.current
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let isSearchActive = !trimmedSearch.isEmpty
        
        return games.filter
        { game in
            
            guard let date = game.date else { return false }
            guard calendar.isDate(date, inSameDayAs: targetDate) else { return false }
            
            if isSearchActive
            {
                let homeTeam = game.homeTeam ?? ""
                let awayTeam = game.awayTeam ?? ""
                
                let matchesHome = homeTeam.localizedCaseInsensitiveContains(trimmedSearch)
                let matchesAway = awayTeam.localizedCaseInsensitiveContains(trimmedSearch)
                
                return matchesHome || matchesAway
            }
            
            return true
        }
        .sorted
        { lhs, rhs in
            guard let leftDate = lhs.date else { return false }
            guard let rightDate = rhs.date else { return true }
            return leftDate < rightDate
        }
    }

    func selectToday()
    {
        selectedDate = Date()
    }
    
    func selectTomorrow()
    {
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        {
            selectedDate = tomorrow
        }
    }
    
    func refreshGames()
    {
        loadGames()
    }
}
