//
//  CustomTab.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 20/10/25.
//

import Foundation

enum CustomTab: String, CaseIterable
{
    case home = "Home"
    case notifications = "Notifications"
    case favoriteTeams = "Favorite Teams"
    case feedback = "Feedback"
    
    var symbol: String
    {
        switch self
        {
            case .home: return "house.fill"
            case .notifications: return "bell.fill"
            case .favoriteTeams: return "heart.fill"
            case .feedback: return "gearshape.fill"
//            case .feedback: return "bubble.left.and.bubble.right.fill"
        }
    }
    
    var activeSymbol: String
    {
        switch self
        {
            case .home: return "house"
            case .notifications: return "bell"
            case .favoriteTeams: return "heart"
            case .feedback: return "gearshape"
//            case .feedback: return "bubble.left.and.bubble.right"
        }
    }
    
    var index: Int
    {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}
