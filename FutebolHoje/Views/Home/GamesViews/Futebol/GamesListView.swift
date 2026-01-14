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
            VStack(spacing: 6)
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
                            icon: "sportscourt",
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
        .refreshable
        {
            await refreshGames()
        }
    }
    
    private var gamesList: some View
    {
        ForEach(viewModel.displayedGames)
        { game in
            GameCardView(game: game)
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
//        HeaderView()
        DatePickerView(viewModel: GamesViewModel())
//        Divider()
        
        GamesListView(viewModel: GamesViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(Color(.systemBackground))
}
