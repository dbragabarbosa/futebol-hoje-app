//
//  GamesView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 08/08/25.
//

import Foundation
import SwiftUI

struct HomeView: View
{
    @State private var activeTab: CustomTab = .home
    @State private var selectedSport: SportType = .futebol
    @State private var isSearchBarFocused: Bool = false
    
    @EnvironmentObject private var notificationsViewModel: GameNotificationsViewModel
    
    private let analytics: AnalyticsService = FirebaseAnalyticsService.shared
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            switch activeTab
            {
                case .home:
                    VStack(spacing: 0)
                    {
                        SportSelectionHeader(selectedSport: $selectedSport)
                        
                        switch selectedSport
                        {
                            case .futebol:
                                FutebolView(isSearchBarFocused: $isSearchBarFocused)
                                
//                            case .nfl:
//                                NFLView()
                                
                            case .nba:
                                NBAView(isSearchBarFocused: $isSearchBarFocused)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .notifications:
                    NotificationsView()
                
//                case .favoriteTeams:
//                    FavoriteTeamsView()
                    
                case .feedback:
                    FeedbackView()
            }
            
            Divider()
            
            if !isSearchBarFocused
            {
                if #available(iOS 26, *)
                {
                    CustomTabBarView(activeTab: $activeTab)
                }
                else
                {
                    TabBarForLoweriOSVersions(activeTab: $activeTab)
                }
//                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
        }
        .background(Color(.systemBackground))
        .onAppear {
            analytics.logScreenView("Home")
        }
        .onChange(of: activeTab) { newValue in
            analytics.logEvent(.tabChanged(newValue))
            isSearchBarFocused = false
        }
        .onChange(of: selectedSport) { newValue in
            analytics.logEvent(.sportSelected(newValue))
            isSearchBarFocused = false
        }
//        .animation(.easeInOut(duration: 0.2), value: isSearchBarFocused)
        .fullScreenCover(isPresented: $notificationsViewModel.isOnboardingPresented)
        {
            NotificationOnboarding(
                config: notificationOnboardingConfig,
                permissionStatus: notificationsViewModel.permissionStatus
            ) {
                notificationOnboardingLogo
            } onPrimaryButtonTap: {
                notificationsViewModel.handleOnboardingPrimaryAction()
            } onSecondaryButtonTap: {
                notificationsViewModel.handleOnboardingSecondaryAction()
            }
        }
    }
    
    private var notificationOnboardingConfig: NotificationOnboardingConfig
    {
        NotificationOnboardingConfig(
            title: "Receba alertas dos\nseus jogos salvos",
            content: "Ative as notificações para ser lembrado do horário e locais de transmissão dos jogos que quiser",
            notificationTitle: "Jogo começando agora",
            notificationContent: "Atlético x Cruzeiro às 21:30\nAssista em: SporTV e Premiere",
            primaryButtonTitle: "Ativar notificações",
            secondaryButtonTitle: "Agora não"
        )
    }
    
    private var notificationOnboardingLogo: some View
    {
        AppNotificationLogoView()
    }
}

#Preview
{
    HomeView()
        .environmentObject(GameNotificationsViewModel())
}
