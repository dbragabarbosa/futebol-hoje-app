//
//  FutebolHojeApp.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 30/07/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate
{
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
  }
}

@main
struct FutebolHojeApp: App
{
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene
    {
        WindowGroup
        {
            NavigationView
            {
//                ContentView()
                GamesView()
            }
        }
    }
}
