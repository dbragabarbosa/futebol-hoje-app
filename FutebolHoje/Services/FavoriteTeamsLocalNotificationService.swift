//
//  FavoriteTeamsLocalNotificationService.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 01/02/26.
//

import Foundation
import UserNotifications

final class FavoriteTeamsLocalNotificationService: FavoriteTeamsNotificationService
{
    static let shared = FavoriteTeamsLocalNotificationService()
    
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
    
    func scheduleGameNotification(game: Game, favoriteTeam: String) async
    {
        guard let gameDate = game.date else
        {
            print("⚠️ Jogo sem data, não é possível agendar notificação")
            return
        }
        
        guard gameDate > Date() else
        {
            print("⚠️ Jogo já passou, não agendando notificação")
            return
        }
        
        let content = createNotificationContent(for: game, favoriteTeam: favoriteTeam)
        let trigger = createTrigger(for: gameDate)
        let identifier = createIdentifier(for: game)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        do
        {
            try await notificationCenter.add(request)
            print("✅ Notificação agendada para: \(gameDate)")
            
            if let gameId = game.id
            {
                analytics.logEvent(.gameNotificationScheduled(team: favoriteTeam, gameId: gameId))
            }
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
    
    func cancelAllPendingNotifications()
    {
        notificationCenter.removeAllPendingNotificationRequests()
        print("🗑️ Todas as notificações pendentes foram canceladas")
    }
    
    func getPendingNotifications() async -> [UNNotificationRequest]
    {
        await notificationCenter.pendingNotificationRequests()
    }

    
    private func createNotificationContent(for game: Game, favoriteTeam: String) -> UNMutableNotificationContent
    {
        let content = UNMutableNotificationContent()
        
        let homeTeam = game.homeTeam ?? "Time A"
        let awayTeam = game.awayTeam ?? "Time B"
        
        content.title = "⚽ Jogo do \(favoriteTeam) agora!"
        content.body = formatNotificationBody(
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            broadcasters: game.broadcasters
        )
        content.sound = .default
        
        return content
    }
    
    private func formatNotificationBody(homeTeam: String, awayTeam: String, broadcasters: [String]?) -> String
    {
        var body = "\(homeTeam) x \(awayTeam)"
        
        if let broadcasters = broadcasters, !broadcasters.isEmpty
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
    
    private func createIdentifier(for game: Game) -> String
    {
        let gameId = game.id ?? UUID().uuidString
        return "game_notification_\(gameId)"
    }
}
