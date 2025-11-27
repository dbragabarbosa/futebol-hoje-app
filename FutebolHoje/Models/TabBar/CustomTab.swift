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
//    case notifications = "Notifications"
//    case settings = "Settings"
    
    var symbol: String
    {
        switch self
        {
            case .home: return "house"
//            case .notifications: return "bell"
//            case .settings: return "gearshape"
        }
    }
    
    var activeSymbol: String
    {
        switch self
        {
            case .home: return "plus"
//            case .notifications: return "tray.full.fill"
//            case .settings: return "cloud.moon.fill"
        }
    }
    
    var index: Int
    {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}
