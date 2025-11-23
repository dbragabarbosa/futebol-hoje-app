//
//  GamesView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 08/08/25.
//

import Foundation
import SwiftUI

struct GamesView: View
{
    @StateObject private var viewModel = GamesViewModel()
    
    @State private var activeTab: CustomTab = .home
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            HeaderView()
            
            DatePickerView()
                .padding(.top)
            
            GamesListView(viewModel: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            
            Divider()
            
//            TabsView()
            CustomTabBarView(activeTab: $activeTab)
        }
        .background(Color(.systemBackground))
    }
}

#Preview
{
    GamesView()
}
