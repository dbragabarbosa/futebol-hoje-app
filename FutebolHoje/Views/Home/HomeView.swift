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
                            .padding(.top, 16)
                        
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
            
            CustomTabBarView(activeTab: $activeTab)
                .padding(.top, 4)
        }
        .background(Color(.systemBackground))
    }
}

#Preview
{
    HomeView()
}
