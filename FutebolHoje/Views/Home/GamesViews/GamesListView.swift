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
            VStack(spacing: 16)
            {
                if viewModel.isLoading
                {
                    loadingView
                }
                else if let errorMessage = viewModel.errorMessage
                {
                    errorView(message: errorMessage)
                }
                else if viewModel.todayGames.isEmpty
                {
                    if viewModel.isConnected
                    {
                        emptyStateView
                    }
                    else
                    {
                        noInternetView
                    }
                }
                else
                {
                    gamesList
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .refreshable
        {
            await refreshGames()
        }
    }
    
    
    private var loadingView: some View
    {
        VStack(spacing: 16)
        {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Carregando jogos...")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .accessibilityLabel("Carregando jogos")
    }
    
    private func errorView(message: String) -> some View
    {
        VStack(spacing: 20)
        {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            
            Text(message)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { viewModel.refreshGames() })
            {
                HStack
                {
                    Image(systemName: "arrow.clockwise")
                    Text("Tentar Novamente")
                }
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Erro: \(message). Botão tentar novamente")
    }
    
    private var noInternetView: some View
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
            }
        )
    }
    
    private var emptyStateView: some View
    {
        ContentUnavailableView(
            icon: "sportscourt",
            title: "Nenhum Jogo Agendado",
            message: "Não encontramos partidas oficiais para hoje em nossa base de dados.",
            buttonTitle: nil,
            action: nil
        )
    }
    
    private var gamesList: some View
    {
        ForEach(viewModel.todayGames)
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

// MARK: - Helper Component
fileprivate struct ContentUnavailableView: View
{
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String?
    let action: (() -> Void)?
    
    var body: some View
    {
        VStack(spacing: 20)
        {
            ZStack
            {
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 8)
            {
                Text(title)
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text(message)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            if let buttonTitle = buttonTitle, let action = action
            {
                Button(action: action)
                {
                    Text(buttonTitle)
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.top, 12)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview("Games List")
{
    VStack(spacing: 0)
    {
//        HeaderView()
        DatePickerView()
        Divider()
        
        GamesListView(viewModel: GamesViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(Color(.systemBackground))
}

#Preview("Empty State - No Internet")
{
    ContentUnavailableView(
        icon: "wifi.slash",
        title: "Sem Conexão",
        message: "Verifique sua conexão com a internet para buscar os jogos.",
        buttonTitle: "Tentar Novamente",
        action: {}
    )
    .background(Color(.systemBackground))
}

#Preview("Empty State - No Games")
{
    ContentUnavailableView(
        icon: "sportscourt",
        title: "Nenhum Jogo Agendado",
        message: "Não encontramos partidas oficiais para hoje em nossa base de dados.",
        buttonTitle: nil,
        action: nil
    )
    .background(Color(.systemBackground))
}

#Preview("OLD Empty State - No Games")
{
    VStack(spacing: 16)
    {
        Image(systemName: "sportscourt")
            .font(.system(size: 64))
            .foregroundStyle(.secondary.opacity(0.5))
        
        Text("Nenhum jogo hoje")
            .font(.system(.title3, design: .rounded))
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
        
        Text("Não há jogos programados para hoje.")
            .font(.system(.subheadline, design: .rounded))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 60)
    .accessibilityElement(children: .combine)
    .accessibilityLabel("Nenhum jogo hoje. Não há jogos programados para hoje.")
}
