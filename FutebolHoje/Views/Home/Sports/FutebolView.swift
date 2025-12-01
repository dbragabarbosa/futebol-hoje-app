//
//  FutebolView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 30/11/25.
//

import SwiftUI

struct FutebolView: View
{
    @StateObject private var viewModel = GamesViewModel()
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            DatePickerView()
                .padding(.top, 4)
            
            HStack(spacing: 12)
            {
                FilterButtonByRegionView(title: "🇧🇷 Brasil", isSelected: viewModel.filterRegions.contains("Brasil"))
                {
                    toggleRegion("Brasil")
                }
                
                FilterButtonByRegionView(title: "🇪🇺 Europa", isSelected: viewModel.filterRegions.contains("Europa"))
                {
                    toggleRegion("Europa")
                }
                
                Spacer()
            }
            .padding(.top, 12)
            .padding(.leading)
            
            if viewModel.filterRegions.isEmpty
            {
                NoRegionSelectedView()
            }
            else
            {
                GamesListView(viewModel: viewModel)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func toggleRegion(_ region: String)
    {
        var newRegions = viewModel.filterRegions
        if newRegions.contains(region)
        {
            newRegions.remove(region)
        }
        else
        {
            newRegions.insert(region)
        }
        viewModel.updateFilter(regions: newRegions)
    }
}

#Preview
{
    FutebolView()
}
