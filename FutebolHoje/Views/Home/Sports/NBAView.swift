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
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            NBADatePickerView(viewModel: viewModel)

            NBAGamesListView(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview
{
    NBAView()
}
