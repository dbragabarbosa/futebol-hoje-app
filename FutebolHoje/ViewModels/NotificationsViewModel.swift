//
//  NotificationsViewModel.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 01/02/26.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor
final class NotificationsViewModel: ObservableObject
{
    @Published var selectedTeam: BrazilianTeam?
    @Published var notificationPermissionGranted: Bool = false
    @Published var todayGamesForFavoriteTeam: [Game] = []
    @Published private var allGames: [Game] = []
    
    private let favoriteTeamManager: FavoriteTeamManager
    private let notificationService: NotificationService
    private let analytics: AnalyticsService
    private let db = Firestore.firestore()
    
    private var cancellables = Set<AnyCancellable>()
    
    var hasFavoriteTeam: Bool
    {
        selectedTeam != nil
    }

    init(favoriteTeamManager: FavoriteTeamManager = FavoriteTeamManager(),
         notificationService: NotificationService = LocalNotificationService.shared,
         analytics: AnalyticsService = FirebaseAnalyticsService.shared)
    {
        self.favoriteTeamManager = favoriteTeamManager
        self.notificationService = notificationService
        self.analytics = analytics
        
        setupBindings()
        loadGames()
        checkNotificationPermission()
    }
    
    func selectTeam(_ team: BrazilianTeam)
    {
        selectedTeam = team
        favoriteTeamManager.setFavoriteTeam(team)
        filterTodayGames()
        
        Task
        {
            await scheduleNotificationsIfNeeded()
        }
    }
    
    func requestNotificationPermission() async
    {
        let granted = await notificationService.requestAuthorization()
        notificationPermissionGranted = granted
        
        if granted
        {
            await scheduleNotificationsIfNeeded()
        }
    }
    
    private func setupBindings()
    {
        selectedTeam = favoriteTeamManager.favoriteTeam
        
        $allGames
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filterTodayGames()
            }
            .store(in: &cancellables)
    }
    
    private func loadGames()
    {
        db.collection("games").addSnapshotListener
        { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error
            {
                print("❌ Erro ao carregar jogos: \(error.localizedDescription)")
                return
            }
            
            do
            {
                self.allGames = try snapshot?.documents.compactMap
                { doc in
                    try doc.data(as: Game.self)
                } ?? []
            }
            catch
            {
                print("❌ Erro ao decodificar jogos: \(error.localizedDescription)")
            }
        }
    }
    
    private func filterTodayGames()
    {
        guard let team = selectedTeam else
        {
            todayGamesForFavoriteTeam = []
            return
        }
        
        let calendar = Calendar.current
        let today = Date()
        
        todayGamesForFavoriteTeam = allGames.filter
        { game in
            guard let gameDate = game.date else { return false }
            guard calendar.isDate(gameDate, inSameDayAs: today) else { return false }
            
            let homeTeam = game.homeTeam ?? ""
            let awayTeam = game.awayTeam ?? ""
            
            return homeTeam.localizedCaseInsensitiveContains(team.rawValue) ||
                   awayTeam.localizedCaseInsensitiveContains(team.rawValue)
        }
        .sorted
        { lhs, rhs in
            guard let leftDate = lhs.date else { return false }
            guard let rightDate = rhs.date else { return true }
            return leftDate < rightDate
        }
    }
    
    private func checkNotificationPermission()
    {
        Task
        {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            notificationPermissionGranted = settings.authorizationStatus == .authorized
        }
    }
    
    private func scheduleNotificationsIfNeeded() async
    {
        guard notificationPermissionGranted else { return }
        guard let team = selectedTeam else { return }
        
        notificationService.cancelAllPendingNotifications()
        
        for game in todayGamesForFavoriteTeam
        {
            await notificationService.scheduleGameNotification(game: game, favoriteTeam: team.displayName)
        }
    }
}
