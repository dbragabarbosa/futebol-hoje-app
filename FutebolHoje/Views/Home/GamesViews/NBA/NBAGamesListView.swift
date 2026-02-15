//
//  NBAGamesListView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 27/12/25.
//

import Foundation
import SwiftUI

struct NBAGamesListView: View
{
    @ObservedObject var viewModel: NBAGamesViewModel
    
    var body: some View
    {
        ScrollView
        {
            LazyVStack(spacing: 6)
            {
                if viewModel.isLoading
                {
                    LoadingView()
                }
                else if let errorMessage = viewModel.errorMessage
                {
                    ErrorView(message: errorMessage,
                              action: { Task { await refreshGames() } } )
                }
                else if viewModel.displayedGames.isEmpty
                {
                    let trimmedSearch = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                    let isSearchActive = !trimmedSearch.isEmpty
                    
                    if isSearchActive
                    {
                        ContentUnavailableView(
                            icon: "magnifyingglass",
                            title: "Nenhum Jogo Encontrado",
                            message: "Não encontramos jogos para '\(trimmedSearch)' no dia selecionado.",
                            buttonTitle: nil,
                            action: nil)
                    }
                    else if viewModel.isConnected
                    {
                        ContentUnavailableView(
                            icon: "basketball.fill",
                            title: "Nenhum Jogo Agendado",
                            message: "Não encontramos partidas oficiais para esse dia em nossa base de dados.",
                            buttonTitle: nil,
                            action: nil)
                    }
                    else
                    {
                        ContentUnavailableView(
                            icon: "wifi.slash",
                            title: "Sem Conexão",
                            message: "Verifique sua conexão com a internet para buscar os jogos.",
                            buttonTitle: "Tentar Novamente",
                            action: {
                                Task {
                                    await refreshGames()
                                }
                            })
                    }
                }
                else
                {
                    gamesList
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .padding(.bottom, 8)
        }
        .scrollDismissesKeyboard(.interactively)
        .refreshable
        {
            await refreshGames()
        }
    }
    
    private var gamesList: some View
    {
        ForEach(viewModel.displayedGames)
        { game in
            NBAGameCardView(game: game)
        }
    }

    @MainActor
    private func refreshGames() async
    {
        viewModel.refreshGames()

        try? await Task.sleep(nanoseconds: 500_000_000)
    }
}

#Preview("Games List")
{
    VStack(spacing: 0)
    {
        NBADatePickerView(viewModel: NBAGamesViewModel())
        
        NBAGamesListView(viewModel: NBAGamesViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(Color(.systemBackground))
    .environmentObject(GameNotificationsViewModel())
}
