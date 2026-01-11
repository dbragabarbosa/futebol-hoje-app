//
//  ThemeManager.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 24/12/25.
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject
{
    @AppStorage("userTheme") private var storedTheme: String = ThemeMode.system.rawValue
    
    @Published var selectedTheme: ThemeMode = .system
    
    private let analytics: AnalyticsService
    
    init(analytics: AnalyticsService = FirebaseAnalyticsService.shared)
    {
        self.analytics = analytics
        
        if let savedTheme = ThemeMode(rawValue: storedTheme)
        {
            selectedTheme = savedTheme
        }
    }
    
    func setTheme(_ theme: ThemeMode)
    {
        selectedTheme = theme
        storedTheme = theme.rawValue
        
        analytics.logEvent(.themeChanged(theme))
    }
    
    var colorScheme: ColorScheme?
    {
        switch selectedTheme
        {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
