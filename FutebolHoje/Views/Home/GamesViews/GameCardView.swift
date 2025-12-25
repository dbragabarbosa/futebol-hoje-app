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
        VStack(alignment: .center, spacing: 6)
        {
            Text(game.competition?.uppercased() ?? "CAMPEONATO")
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .tracking(1)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 0)
            {
                Text(game.homeTeam ?? "Time A")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
                    .minimumScaleFactor(0.1)

                VStack
                {
                    if let date = game.date
                    {
                        Text(date.formatted(date: .omitted, time: .shortened))
                            .font(.system(.body, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 0)
//                            .background(Color(.tertiarySystemGroupedBackground))
//                            .clipShape(Capsule())
                    }
                    else
                    {
                        Text("VS")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 80)
                
                Text(game.awayTeam ?? "Time B")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
                    .minimumScaleFactor(0.1)
            }
            
            if let broadcasters = game.broadcasters, !broadcasters.isEmpty
            {
                ViewThatFits(in: .horizontal)
                {
                    HStack(spacing: 8)
                    {
                        broadcasterPills(broadcasters)
                    }

                    ScrollView(.horizontal, showsIndicators: false)
                    {
                        HStack(spacing: 6)
                        {
                            broadcasterPills(broadcasters)
                        }
                    }
                }
            }
        }
        .padding(12)
//        .background
//        {
//            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                .fill(.regularMaterial)
//                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
//        }
//        .overlay
//        {
//            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                .stroke(.white.opacity(0.2), lineWidth: 1)
//        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    private func broadcasterPills(_ broadcasters: [String]) -> some View
    {
        ForEach(broadcasters, id: \.self)
        { broadcaster in
            Text(broadcaster.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color.AppTheme.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.AppTheme.secondary.opacity(0.1))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.AppTheme.secondary.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private var accessibilityLabel: String
    {
        let home = game.homeTeam ?? "Time A"
        let away = game.awayTeam ?? "Time B"
        let competition = game.competition ?? "Campeonato"

        var timeString = ""
        if let date = game.date
        {
            timeString = " às \(date.formatted(date: .omitted, time: .shortened))"
        }
        
        return "\(competition). \(home) contra \(away)\(timeString)"
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
            broadcasters: ["SporTV", "Premiere", "YouTube (ESPN Brasil)", "YouTube (CazéTV)"],
            region: "Brasil",
            sportType: nil,
            homeTeamColor: nil,
            awayTeamColor: nil
        ))
        
        GameCardView(game: Game(
            id: nil,
            homeTeam: "Corinthians Corinthians Corinthians",
            awayTeam: "São Paulo",
            date: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
            competition: "Brasileirão Série A",
            broadcasters: ["Globo"],
            region: "Europa",
            sportType: nil,
            homeTeamColor: nil,
            awayTeamColor: nil
        ))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
