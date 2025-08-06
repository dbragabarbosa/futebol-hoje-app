//
//  GamesViewModel.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 05/08/25.
//

import Foundation

class GamesViewModel: ObservableObject
{
    @Published var games: [Game] = []

    func fetchGames()
    {
        // 
    }
}
