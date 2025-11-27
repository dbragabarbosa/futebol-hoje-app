//
//  GameCardView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 13/10/25.
//

import Foundation
import SwiftUI

struct GameCardView: View
{
    let game: Game
    
    var body: some View
    {
        VStack(alignment: .center, spacing: 12)
        {
            Text(game.competition ?? "Campeonato Brasileiro")
                .font(.system(.caption, design: .rounded))
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.bottom, 2)
            
            HStack(spacing: 16)
            {
                Text(game.homeTeam ?? "Time A")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                VStack(spacing: 8)
                {
                    if let date = game.date
                    {
                        Text(date.formatted(date: .omitted, time: .shortened))
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }
                }
                .frame(minWidth: 80)
                
                Text(game.awayTeam ?? "Time B")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            
            if let broadcasters = game.broadcasters,
               !broadcasters.isEmpty
            {
                let broadcastersText = broadcasters.joined(separator: ", ")
                
                Text(broadcastersText)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
        }
        .padding(16)
        .background
        {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .overlay
        {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var accessibilityLabel: String
    {
        let home = game.homeTeam ?? "Time A"
        let away = game.awayTeam ?? "Time B"
        let competition = game.competition ?? "Campeonato Brasileiro"
        var timeString = ""
        
        if let date = game.date
        {
            timeString = " às \(date.formatted(date: .omitted, time: .shortened))"
        }
        
        var broadcastersString = ""
        if let broadcasters = game.broadcasters, !broadcasters.isEmpty
        {
            broadcastersString = " transmitido por \(broadcasters.joined(separator: " e "))"
        }
        
        return "\(home) contra \(away)\(timeString), \(competition)\(broadcastersString)"
    }
}

#Preview
{
    VStack(spacing: 16)
    {
        GameCardView(game: Game(
            id: nil,
            homeTeam: "Galo",
            awayTeam: "Palmeiras",
            date: Date(),
            competition: "Campeonato Brasileiro",
            homeTeamColor: nil,
            awayTeamColor: nil,
            broadcasters: ["SporTV", "Premiere"]
        ))
        
        GameCardView(game: Game(
            id: nil,
            homeTeam: "Corinthians",
            awayTeam: "São Paulo",
            date: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
            competition: "Brasileirão Série A",
            homeTeamColor: nil,
            awayTeamColor: nil,
            broadcasters: ["Globo"]
        ))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
