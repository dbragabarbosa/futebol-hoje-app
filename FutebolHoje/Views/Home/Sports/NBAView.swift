//
//  NBAView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 30/11/25.
//

import SwiftUI

struct NBAView: View
{
    @StateObject private var viewModel = NBAGamesViewModel()
    @Binding var isSearchBarFocused: Bool
    
    init(isSearchBarFocused: Binding<Bool> = .constant(false))
    {
        self._isSearchBarFocused = isSearchBarFocused
    }
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            NBADatePickerView(viewModel: viewModel)

            TeamSearchBar(searchText: $viewModel.searchText, isFocused: $isSearchBarFocused)

            NBAGamesListView(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview
{
    NBAView(isSearchBarFocused: .constant(false))
}
