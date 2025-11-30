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
    case feedback = "Feedback"
//    case notifications = "Notifications"
//    case settings = "Settings"
//    case review = "Review"
//    case feedback2 = "Feedback "
//    case more = "More"
//    case apoie = "Apoie"
//    case apoie2 = "Apoie "
    
    var symbol: String
    {
        switch self
        {
            case .home: return "house"
            case .feedback: return "bubble.left.and.bubble.right.fill"
//            case .notifications: return "bell"
//            case .settings: return "gearshape"
//            case .review: return "star.fill"
//            case .feedback2: return "envelope.open.fill"
//            case .more: return "ellipsis"
//            case .apoie: return "hand.thumbsup.fill"
//            case .apoie2: return "heart.fill"
        }
    }
    
    var activeSymbol: String
    {
        switch self
        {
            case .home: return "plus"
            case .feedback: return "bubble.left.and.bubble.right"
//            case .notifications: return "tray.full.fill"
//            case .settings: return "cloud.moon.fill"
//            case .review: return "star"
//            case .feedback2: return "envelope.open"
//            case .more: return "ellipsis.circle"
//            case .apoie: return "hand.thumbsup"
//            case .apoie2: return "heart"
        }
    }
    
    var index: Int
    {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}
