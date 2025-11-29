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
    @StateObject private var viewModel = GamesViewModel()
    
    @State private var activeTab: CustomTab = .home
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            switch activeTab
            {
                case .home:
                    VStack(spacing: 0)
                    {
                        DatePickerView()
                            .padding(.top)
                        
                        GamesListView(viewModel: viewModel)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .review:
                    ReviewView()
            }
            
            Divider()
            
            CustomTabBarView(activeTab: $activeTab)
                .padding(.top, 8)
        }
        .background(Color(.systemBackground))
    }
}

#Preview
{
    HomeView()
}
