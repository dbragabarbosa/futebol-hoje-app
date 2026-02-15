//
//  GameNotificationSport.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import Foundation

enum GameNotificationSport: String, Codable, CaseIterable, Identifiable
{
    case futebol
    case nba
    
    var id: String { rawValue }
    
    var displayName: String
    {
        switch self
        {
            case .futebol: return "Futebol"
            case .nba: return "NBA"
        }
    }
    
    var icon: String
    {
        switch self
        {
            case .futebol: return "⚽️"
            case .nba: return "🏀"
        }
    }
}
