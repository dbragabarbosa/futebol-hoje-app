//
//  GamesListView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 05/08/25.
//

import SwiftUI

struct GamesListView: View
{
    @StateObject var viewModel = GamesViewModel()

    var body: some View
    {
        List(viewModel.games)
        { game in
            
            GameRowView(game: game)
        }
        .onAppear
        {
            viewModel.fetchGames()
        }
    }
}

#Preview
{
    GamesListView()
}
