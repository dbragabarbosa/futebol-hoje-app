//
//  GameNotificationsViewModel.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import Foundation
import Combine
import UserNotifications
import UIKit

@MainActor
final class GameNotificationsViewModel: ObservableObject
{
    @Published private(set) var games: [NotifiedGame] = []
    @Published var notificationPermissionGranted: Bool = false
    
    private var permissionStatus: NotificationPermissionStatus = .notDetermined
    private var cancellables = Set<AnyCancellable>()
    
    private let store: GameNotificationsStore
    private let notificationService: GameNotificationsService
    init(store: GameNotificationsStore,
         notificationService: GameNotificationsService)
    {
        self.store = store
        self.notificationService = notificationService
        
        bindStore()
        cleanupExpiredGames()
        setupDayChangeListener()
        setupForegroundListener()
        checkNotificationPermission()
    }
    
    convenience init()
    {
        self.init(
            store: GameNotificationsStore(),
            notificationService: GameNotificationsLocalService.shared
        )
    }
    
    func toggleNotification(for game: Game, sport: GameNotificationSport)
    {
        guard let notifiedGame = NotifiedGame(game: game, sport: sport) else { return }
        let identifier = notifiedGame.id
        
        if store.contains(id: identifier)
        {
            if let removed = store.remove(id: identifier)
            {
                notificationService.cancelNotifications(ids: [removed.id])
            }
            return
        }
        
        store.upsert(notifiedGame)
        Task
        {
            await scheduleNotificationIfAllowed(for: notifiedGame)
        }
    }
    
    func isNotified(game: Game, sport: GameNotificationSport) -> Bool
    {
        store.contains(game: game, sport: sport)
    }
    
    func requestNotificationPermission() async
    {
        if permissionStatus == .denied
        {
            openSettings()
            return
        }
        
        let granted = await notificationService.requestAuthorization()
        setPermissionStatus(granted ? .authorized : .denied)
        
        if granted
        {
            await scheduleAllPendingNotifications()
        }
    }
    
    func checkNotificationPermission()
    {
        cleanupExpiredGames()
        
        Task
        {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            switch settings.authorizationStatus
            {
                case .authorized, .provisional, .ephemeral:
                    setPermissionStatus(.authorized)
                    await scheduleAllPendingNotifications()
                case .denied:
                    setPermissionStatus(.denied)
                default:
                    setPermissionStatus(.notDetermined)
            }
        }
    }
    
    private func bindStore()
    {
        store.$games
            .receive(on: DispatchQueue.main)
            .assign(to: &$games)
    }
    
    private func setupDayChangeListener()
    {
        NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cleanupExpiredGames()
            }
            .store(in: &cancellables)
    }
    
    private func setupForegroundListener()
    {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.checkNotificationPermission()
            }
            .store(in: &cancellables)
    }
    
    private func setPermissionStatus(_ status: NotificationPermissionStatus)
    {
        permissionStatus = status
        notificationPermissionGranted = status == .authorized
    }
    
    private func scheduleNotificationIfAllowed(for game: NotifiedGame) async
    {
        let canSchedule = await ensureAuthorizationIfNeeded()
        guard canSchedule else { return }
        await notificationService.scheduleNotification(for: game)
    }
    
    private func ensureAuthorizationIfNeeded() async -> Bool
    {
        if notificationPermissionGranted
        {
            return true
        }
        
        if permissionStatus == .notDetermined
        {
            let granted = await notificationService.requestAuthorization()
            setPermissionStatus(granted ? .authorized : .denied)
            return granted
        }
        
        return false
    }
    
    private func scheduleAllPendingNotifications() async
    {
        guard notificationPermissionGranted else { return }
        
        for game in games
        {
            await notificationService.scheduleNotification(for: game)
        }
    }
    
    private func cleanupExpiredGames()
    {
        let expiredGames = store.removeExpiredGames()
        let expiredIds = expiredGames.map { $0.id }
        if !expiredIds.isEmpty
        {
            notificationService.cancelNotifications(ids: expiredIds)
        }
    }
    
    private func openSettings()
    {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
