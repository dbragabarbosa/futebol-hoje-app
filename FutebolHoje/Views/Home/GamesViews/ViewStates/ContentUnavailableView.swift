//
//  ErrorView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 27/12/25.
//

import SwiftUI

struct ContentUnavailableView: View
{
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String?
    let action: (() -> Void)?
    
    var body: some View
    {
        VStack(spacing: 24)
        {
            Spacer()
            
            ZStack
            {
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 56))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 12)
            {
                Text(title)
                    .font(.system(.title2))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text(message)
                    .font(.system(.body))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
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
                                colors: [Color.AppTheme.primary, Color.AppTheme.primary],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color.AppTheme.primary.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.top, 12)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview("Empty State - No games in search")
{
    ContentUnavailableView(
        icon: "magnifyingglass",
        title: "Nenhum Jogo Encontrado",
        message: "Não encontramos jogos para 'BUSCA' no dia selecionado.",
        buttonTitle: nil,
        action: nil)
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
        message: "Não encontramos partidas oficiais para esse dia em nossa base de dados.",
        buttonTitle: nil,
        action: nil
    )
    .background(Color(.systemBackground))
}

#Preview("Empty State - NBA No Game")
{
    ContentUnavailableView(
        icon: "basketball.fill",
        title: "Nenhum Jogo Agendado",
        message: "Não encontramos partidas oficiais para esse dia em nossa base de dados.",
        buttonTitle: nil,
        action: nil
    )
    .background(Color(.systemBackground))
}
