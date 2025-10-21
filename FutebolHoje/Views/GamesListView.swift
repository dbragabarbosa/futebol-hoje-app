//
//  GamesListView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 05/08/25.
//

import Foundation
import SwiftUI

struct GamesListView: View
{
    @ObservedObject var viewModel: GamesViewModel
    
    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 12)
            {
                if viewModel.todayGames.isEmpty
                {
                    Text("Nenhum jogo hoje.")
                        .foregroundColor(.secondary)
                        .padding(.top, 40)
                }
                else
                {
                    ForEach(viewModel.todayGames)
                    { game in
                        GameCardView(game: game)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview
{
    GamesListView(viewModel: GamesViewModel.init())
}
