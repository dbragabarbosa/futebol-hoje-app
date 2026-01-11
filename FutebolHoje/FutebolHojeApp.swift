//
//  FutebolHojeApp.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 30/07/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate
{
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
    {
        FirebaseApp.configure()

        #if DEBUG
        Analytics.setAnalyticsCollectionEnabled(true)
        print("🔥 Firebase Analytics configured in DEBUG mode")
        #endif

        let analytics = FirebaseAnalyticsService.shared
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            analytics.setUserProperty("app_version", value: appVersion)
        }
        if let language = Locale.current.language.languageCode?.identifier {
            analytics.setUserProperty("language", value: language)
        }
        
        return true
  }
}

@main
struct FutebolHojeApp: App
{
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene
    {
        WindowGroup
        {
            NavigationView
            {
//                ContentView()
                HomeView()
            }
            .navigationViewStyle(.stack)
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
