//
//  GameNotificationsService.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import Foundation

protocol GameNotificationsService
{
    func requestAuthorization() async -> Bool
    func scheduleNotification(for game: NotifiedGame) async
    func cancelNotifications(ids: [String])
}
