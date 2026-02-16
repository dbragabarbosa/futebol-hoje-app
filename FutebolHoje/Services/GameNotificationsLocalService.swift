//
//  GameNotificationsLocalService.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import Foundation
import UserNotifications

final class GameNotificationsLocalService: GameNotificationsService
{
    static let shared = GameNotificationsLocalService()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let analytics: AnalyticsService
    
    init(analytics: AnalyticsService = FirebaseAnalyticsService.shared)
    {
        self.analytics = analytics
    }
    
    func requestAuthorization() async -> Bool
    {
        do
        {
            let granted = try await notificationCenter.requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            analytics.logEvent(.notificationPermissionRequested(granted: granted))
            return granted
        }
        catch
        {
            print("❌ Erro ao solicitar permissão de notificação: \(error.localizedDescription)")
            analytics.logEvent(.error(
                message: "Notification permission request failed",
                context: "requestAuthorization"
            ))
            return false
        }
    }
    
    func scheduleNotification(for game: NotifiedGame, triggerDate: Date, identifier: String, timingOption: NotificationTimingOption) async
    {
        guard triggerDate > Date() else
        {
            print("⚠️ Horário de notificação já passou, não agendando")
            return
        }
        
        let content = createNotificationContent(for: game, timingOption: timingOption)
        let trigger = createTrigger(for: triggerDate)
        let identifier = notificationIdentifier(for: identifier)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        do
        {
            try await notificationCenter.add(request)
            print("✅ Notificação agendada para: \(triggerDate)")
        }
        catch
        {
            print("❌ Erro ao agendar notificação: \(error.localizedDescription)")
            analytics.logEvent(.error(
                message: "Failed to schedule notification",
                context: "scheduleGameNotification"
            ))
        }
    }
    
    func cancelNotifications(ids: [String])
    {
        let identifiers = ids.map(notificationIdentifier(for:))
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    private func createNotificationContent(for game: NotifiedGame, timingOption: NotificationTimingOption) -> UNMutableNotificationContent
    {
        let content = UNMutableNotificationContent()
        
        content.title = "\(game.sport.icon) \(timingOption.notificationTitle)"
        content.body = formatNotificationBody(for: game)
        content.sound = .default
        
        return content
    }
    
    private func formatNotificationBody(for game: NotifiedGame) -> String
    {
        var body = "\(game.homeTeam) x \(game.awayTeam)"
        
//        if let competition = game.competition, !competition.isEmpty
//        {
//            body += "\n\(competition)"
//        }
        
        if let broadcasters = game.broadcasters, !broadcasters.isEmpty
        {
            let broadcastersText = broadcasters.joined(separator: ", ")
            body += "\n📺 Assista em: \(broadcastersText)"
        }
        
        return body
    }
    
    private func createTrigger(for date: Date) -> UNCalendarNotificationTrigger
    {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
    
    private func notificationIdentifier(for id: String) -> String
    {
        "game_notification_\(id)"
    }
}
