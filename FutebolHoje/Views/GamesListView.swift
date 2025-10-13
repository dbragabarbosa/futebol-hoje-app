//
//  GamesListView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 05/08/25.
//

import SwiftUI

//struct GamesListView: View
//{
//    @StateObject var viewModel = GamesViewModel()

//    var body: some View
//    {
//        Text("Hello, World!")
        
//        List(viewModel.games)
//        { game in
//            
//            GameRowView(game: game)
//        }
//        .onAppear
//        {
//            viewModel.fetchGames()
//        }
//    }
//}

struct GamesListView: View
{
    var body: some View
    {
        // MARK: - Lista de jogos
        ScrollView
        {
            VStack(spacing: 12)
            {
                ForEach(0..<5, id: \.self)
                { _ in
                    
                    GameCardView()
                }
            }
            .padding()
        }
    }
}

#Preview
{
    GamesListView()
}
