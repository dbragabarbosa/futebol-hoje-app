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
                    emptyStateView
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
    
    private var emptyStateView: some View
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

#Preview
{
    VStack(spacing: 0)
    {
        HeaderView()
        DatePickerView()
        Divider()
        
        GamesListView(viewModel: GamesViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(Color(.systemBackground))
}
