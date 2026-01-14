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
    @Published var displayedGames: [Game] = []
    @Published var selectedDate: Date = Date()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var filterRegions: Set<String> = ["Brasil"]
    @Published var selectedCompetitions: Set<String> = []
    @Published var availableCompetitions: [String] = []
    @Published var isAllCompetitionsSelected: Bool = true
    @Published var isConnected: Bool = true
    @Published var allGames: [Game] = []
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let db = Firestore.firestore()
    private let networkMonitor = NetworkMonitor()
    private let analytics: AnalyticsService
    
    init(analytics: AnalyticsService = FirebaseAnalyticsService.shared)
    {
        self.analytics = analytics
        setupNetworkMonitoring()
        setupPipeline()
        loadGames()
    }
    
//    init(analytics: AnalyticsService? = nil)
//    {
//        self.analytics = analytics ?? FirebaseAnalyticsService.shared
//        setupNetworkMonitoring()
//        setupPipeline()
//        loadGames()
//    }
    
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
        Publishers.CombineLatest(
            Publishers.CombineLatest4($allGames, $selectedDate, $filterRegions, $selectedCompetitions),
            $searchText
        )
            .receive(on: DispatchQueue.main)
            .map { [weak self] (combined, searchText) -> [Game] in
                guard let self = self else { return [] }
                let (games, date, regions, competitions) = combined
                return self.filterGames(
                    games,
                    date: date,
                    regions: regions,
                    competitions: competitions,
                    isAllCompetitionsSelected: self.isAllCompetitionsSelected,
                    searchText: searchText
                )
            }
            .assign(to: &$displayedGames)
        
        $selectedCompetitions
            .map { $0.isEmpty }
            .assign(to: &$isAllCompetitionsSelected)
            
        NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if Calendar.current.isDateInToday(self.selectedDate) {
                    self.selectedDate = Date()
                }
            }
            .store(in: &cancellables)
        
        $selectedDate
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] date in
                self?.analytics.logEvent(.dateFilterChanged(date))
            }
            .store(in: &cancellables)

        Publishers.CombineLatest3($allGames, $selectedDate, $filterRegions)
            .receive(on: DispatchQueue.main)
            .map { [weak self] (games, date, regions) -> [String] in
                guard let self = self else { return [] }
                return self.calculateAvailableCompetitions(games: games, date: date, regions: regions)
            }
            .assign(to: &$availableCompetitions)
        
        Publishers.CombineLatest($searchText, $displayedGames)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] (searchText, displayedGames) in
                guard let self = self else { return }
                let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedSearch.isEmpty
                {
                    self.analytics.logEvent(.teamSearchPerformed(
                        query: trimmedSearch,
                        resultsCount: displayedGames.count,
                        sport: "Futebol"
                    ))
                }
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
                self.analytics.logEvent(.error(message: "Failed to load games", context: "loadGames"))
                if !self.isConnected {
                    self.analytics.logEvent(.networkError(context: "loadGames"))
                }
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
                self.analytics.logEvent(.error(message: "Failed to decode games", context: "loadGames"))
            }
        }
    }
    
    func updateFilter(regions: Set<String>)
    {
        self.filterRegions = regions
        analytics.logEvent(.regionFilterChanged(regions))
        
        if !isAllCompetitionsSelected
        {
            let currentAvailableCompetitions = Set(availableCompetitions)
            let selectedStillAvailable = selectedCompetitions.filter { currentAvailableCompetitions.contains($0) }
            
            if selectedStillAvailable.isEmpty
            {
                isAllCompetitionsSelected = true
                selectedCompetitions = []
            }
            else
            {
                selectedCompetitions = selectedStillAvailable
            }
        }
        
    }
    
    private func filterGames(_ games: [Game], date targetDate: Date, regions: Set<String>, competitions: Set<String>, isAllCompetitionsSelected: Bool, searchText: String) -> [Game]
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

            if regions.isEmpty { return false }
            
            let normalizedRegion = determineRegion(for: game)
            guard regions.contains(normalizedRegion) else { return false }
            
            if !isAllCompetitionsSelected
            {
                guard let competition = game.competition else { return false }
                guard competitions.contains(competition) else { return false }
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
    
    private func calculateAvailableCompetitions(games: [Game], date targetDate: Date, regions: Set<String>) -> [String]
    {
        let calendar = Calendar.current
        
        let competitionsSet = Set(
            games
                .filter { game in
                    guard let date = game.date else { return false }
                    guard calendar.isDate(date, inSameDayAs: targetDate) else { return false }
                    
                    if regions.isEmpty { return false }
                    
                    let normalizedRegion = determineRegion(for: game)
                    return regions.contains(normalizedRegion)
                }
                .compactMap { $0.competition }
        )
        
        return competitionsSet.sorted()
    }
    
    func toggleCompetition(_ competition: String)
    {
        let wasSelected = selectedCompetitions.contains(competition)
        
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

        analytics.logEvent(.competitionFilterChanged(competition: competition, isSelected: !wasSelected))
    }
    
    func selectAllCompetitions()
    {
        isAllCompetitionsSelected = true
        selectedCompetitions = []
        analytics.logEvent(.allCompetitionsSelected)
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
    
    private static let europeanCompetitions = [
        "UEFA Champions League", "UEFA Europa League", "UEFA Conference League",
        "Campeonato Alemão", "Campeonato Espanhol", "Campeonato Francês",
        "Campeonato Inglês", "Campeonato Italiano", "Campeonato Português",
        "Copa da Inglaterra", "Copa da Liga Inglesa", "Copa do Rei",
        "Copa da Itália", "Copa da Alemanha", "Copa da França", "Taça de Portugal"
    ]
    
    private func determineRegion(for game: Game) -> String
    {
        let competition = game.competition ?? ""
        
        if Self.europeanCompetitions.contains(where: { competition.contains($0) })
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
