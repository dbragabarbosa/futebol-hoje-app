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
import SwiftUI

@MainActor
final class GameNotificationsViewModel: ObservableObject
{
    @Published private(set) var games: [NotifiedGame] = []
    @Published var notificationPermissionGranted: Bool = false
    @Published private(set) var permissionStatus: NotificationPermissionStatus = .notDetermined
    @Published var isOnboardingPresented: Bool = false
    @Published private(set) var selectedTimingOptions: [NotificationTimingOption] = []
    
    @AppStorage("hasSeenNotificationOnboarding") private var hasSeenNotificationOnboarding: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let store: GameNotificationsStore
    private let timingStore: NotificationTimingStore
    private let notificationService: GameNotificationsService
    init(store: GameNotificationsStore,
         timingStore: NotificationTimingStore,
         notificationService: GameNotificationsService)
    {
        self.store = store
        self.timingStore = timingStore
        self.notificationService = notificationService
        
        bindStore()
        bindTimingStore()
        cleanupExpiredGames()
        setupDayChangeListener()
        setupForegroundListener()
        checkNotificationPermission()
    }
    
    convenience init()
    {
        self.init(
            store: GameNotificationsStore(),
            timingStore: NotificationTimingStore(),
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
                cancelNotifications(for: removed.id)
            }
            return
        }
        
        store.upsert(notifiedGame)
        Task
        {
            await scheduleNotificationsIfAllowed(for: notifiedGame)
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
    
    func handlePermissionCTA()
    {
        switch permissionStatus
        {
            case .notDetermined:
                presentOnboardingIfNeeded()
            case .denied:
                openSettings()
            case .authorized:
                break
        }
    }
    
    func handleOnboardingPrimaryAction()
    {
        switch permissionStatus
        {
            case .authorized:
                dismissOnboarding()
            case .denied:
                openSettings()
            case .notDetermined:
                Task
                {
                    await requestNotificationPermission()
                }
        }
    }
    
    func handleOnboardingSecondaryAction()
    {
        hasSeenNotificationOnboarding = true
        dismissOnboarding()
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
    
    private func bindTimingStore()
    {
        timingStore.$selectedOptions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] options in
                guard let self = self else { return }
                self.selectedTimingOptions = options.sorted { $0.sortOrder < $1.sortOrder }
                
                Task
                {
                    await self.rescheduleNotificationsForAllGames()
                }
            }
            .store(in: &cancellables)
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
        
        if status != .notDetermined
        {
            isOnboardingPresented = false
        }
    }
    
    private func scheduleNotificationsIfAllowed(for game: NotifiedGame) async
    {
        guard notificationPermissionGranted else
        {
            if permissionStatus == .notDetermined
            {
                presentOnboardingIfNeeded()
            }
            return
        }
        
        await scheduleNotifications(for: game)
    }
    
    private func scheduleAllPendingNotifications() async
    {
        guard notificationPermissionGranted else { return }
        
        for game in games
        {
            await scheduleNotifications(for: game)
        }
    }
    
    private func cleanupExpiredGames()
    {
        let expiredGames = store.removeExpiredGames()
        let expiredIds = expiredGames.map { $0.id }
        if !expiredIds.isEmpty
        {
            cancelNotifications(for: expiredIds)
        }
    }
    
    private func openSettings()
    {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func presentOnboardingIfNeeded()
    {
        guard permissionStatus == .notDetermined else { return }
        
        if hasSeenNotificationOnboarding
        {
            Task
            {
                await requestNotificationPermission()
            }
            return
        }
        
        hasSeenNotificationOnboarding = true
        isOnboardingPresented = true
    }
    
    private func dismissOnboarding()
    {
        isOnboardingPresented = false
    }
    
    func toggleTimingOption(_ option: NotificationTimingOption)
    {
        timingStore.toggle(option)
    }
    
    func isTimingSelected(_ option: NotificationTimingOption) -> Bool
    {
        timingStore.isSelected(option)
    }
    
    private func rescheduleNotificationsForAllGames() async
    {
        guard notificationPermissionGranted else { return }
        
        for game in games
        {
            await scheduleNotifications(for: game)
        }
    }
    
    private func scheduleNotifications(for game: NotifiedGame) async
    {
        cancelNotifications(for: game.id)
        
        guard !selectedTimingOptions.isEmpty else { return }
        
        for option in selectedTimingOptions
        {
            let triggerDate = game.date.addingTimeInterval(option.offset)
            if triggerDate <= Date() { continue }
            let identifier = notificationIdentifier(for: game.id, option: option)
            await notificationService.scheduleNotification(
                for: game,
                triggerDate: triggerDate,
                identifier: identifier,
                timingOption: option
            )
        }
    }
    
    private func cancelNotifications(for gameId: String)
    {
        let ids = NotificationTimingOption.allCases.map { notificationIdentifier(for: gameId, option: $0) }
        cancelNotifications(for: ids)
    }
    
    private func cancelNotifications(for gameIds: [String])
    {
        var ids: [String] = []
        for gameId in gameIds
        {
            ids.append(contentsOf: NotificationTimingOption.allCases.map {
                notificationIdentifier(for: gameId, option: $0)
            })
        }
        notificationService.cancelNotifications(ids: ids)
    }
    
    private func notificationIdentifier(for gameId: String, option: NotificationTimingOption) -> String
    {
        "\(gameId)_\(option.rawValue)"
    }
}
