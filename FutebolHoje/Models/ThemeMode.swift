//
//  ThemeMode.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 24/12/25.
//

import Foundation

enum ThemeMode: String, CaseIterable
{
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var displayName: String
    {
        switch self
        {
        case .system:
            return "Automático"
        case .light:
            return "Claro"
        case .dark:
            return "Escuro"
        }
    }
    
    var icon: String
    {
        switch self
        {
        case .system:
            return "gearshape.fill"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
}
