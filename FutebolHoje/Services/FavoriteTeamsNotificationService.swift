//
//  FavoriteTeamsNotificationService.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 01/02/26.
//

import Foundation
import UserNotifications

protocol FavoriteTeamsNotificationService
{
    func requestAuthorization() async -> Bool
    
    func scheduleGameNotification(game: Game, favoriteTeam: String) async
    
    func cancelAllPendingNotifications()
    
    func getPendingNotifications() async -> [UNNotificationRequest]
}
