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
                
                case .favoriteTeams:
                    FavoriteTeamsView()
                    
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
    }
}

#Preview
{
    HomeView()
}
