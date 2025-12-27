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
    @State private var showCompetitionSelector = false
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            DatePickerView(viewModel: viewModel)
            
            HStack(spacing: 12)
            {
                FilterButtonByRegionView(title: "🇧🇷 Brasil", isSelected: viewModel.filterRegions.contains("Brasil"))
                {
                    toggleRegion("Brasil")
                }
                
                FilterButtonByRegionView(title: "🌏 Mundo", isSelected: viewModel.filterRegions.contains("Europa"))
                {
                    toggleRegion("Europa")
                }
                
                Spacer()
            }
            
            if !viewModel.filterRegions.isEmpty && !viewModel.availableCompetitions.isEmpty
            {
                CompetitionFilterButtons(
                    viewModel: viewModel,
                    showCompetitionSelector: $showCompetitionSelector
                )
            }
            
            if viewModel.filterRegions.isEmpty
            {
                NoRegionSelectedView()
            }
            else
            {
                GamesListView(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showCompetitionSelector)
        {
            CompetitionSelectorSheet(viewModel: viewModel)
        }
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
