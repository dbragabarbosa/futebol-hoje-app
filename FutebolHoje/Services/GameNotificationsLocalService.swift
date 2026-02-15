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
    
    func scheduleNotification(for game: NotifiedGame) async
    {
        guard game.date > Date() else
        {
            print("⚠️ Jogo já passou, não agendando notificação")
            return
        }
        
        let content = createNotificationContent(for: game)
        let trigger = createTrigger(for: game.date)
        let identifier = notificationIdentifier(for: game.id)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        do
        {
            try await notificationCenter.add(request)
            print("✅ Notificação agendada para: \(game.date)")
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
    
    private func createNotificationContent(for game: NotifiedGame) -> UNMutableNotificationContent
    {
        let content = UNMutableNotificationContent()
        
        content.title = "\(game.sport.icon) Jogo começando agora"
        content.body = formatNotificationBody(for: game)
        content.sound = .default
        
        return content
    }
    
    private func formatNotificationBody(for game: NotifiedGame) -> String
    {
        var body = "\(game.homeTeam) x \(game.awayTeam)"
        
        if let competition = game.competition, !competition.isEmpty
        {
            body += "\n\(competition)"
        }
        
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
