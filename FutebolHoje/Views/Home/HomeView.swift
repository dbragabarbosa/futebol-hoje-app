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
                                FutebolView()
                                
                            case .nfl:
                                NFLView()
                                
                            case .nba:
                                NBAView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .feedback:
                    FeedbackView()
            }
            
            Divider()
            
            if #available(iOS 26, *)
            {
                CustomTabBarView(activeTab: $activeTab)
            }
            else
            {
                TabBarForLoweriOSVersions(activeTab: $activeTab)
            }
            
        }
        .background(Color(.systemBackground))
        .onAppear {
            analytics.logScreenView("Home")
        }
        .onChange(of: activeTab) { newValue in
            analytics.logEvent(.tabChanged(newValue))
        }
        .onChange(of: selectedSport) { newValue in
            analytics.logEvent(.sportSelected(newValue))
        }
    }
}

#Preview
{
    HomeView()
}
