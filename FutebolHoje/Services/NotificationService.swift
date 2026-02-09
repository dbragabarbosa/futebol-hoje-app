//
//  NotificationService.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 01/02/26.
//

import Foundation
import UserNotifications

/// Protocolo para abstração do serviço de notificações.
/// Permite trocar a implementação (Local → Push) sem alterar o restante do código.
protocol NotificationService
{
    func requestAuthorization() async -> Bool
    
    func scheduleGameNotification(game: Game, favoriteTeam: String) async
    
    func cancelAllPendingNotifications()
    
    func getPendingNotifications() async -> [UNNotificationRequest]
}
