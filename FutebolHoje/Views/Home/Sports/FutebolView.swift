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
            
            GamesListView(viewModel: viewModel)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview
{
    FutebolView()
}
