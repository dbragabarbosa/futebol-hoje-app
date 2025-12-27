//
//  NBAGameCardView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 27/12/25.
//

import Foundation
import SwiftUI

struct NBAGameCardView: View
{
    let game: Game
    
    var body: some View
    {
        VStack(alignment: .center, spacing: 10)
        {
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
                        HStack(spacing: 8)
                        {
                            broadcasterPills(broadcasters)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    private func broadcasterPills(_ broadcasters: [String]) -> some View
    {
        ForEach(broadcasters, id: \.self)
        { broadcaster in
            Text(broadcaster.uppercased())
                .font(.system(size: 12, weight: .bold))
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

        var timeString = ""
        if let date = game.date
        {
            timeString = " às \(date.formatted(date: .omitted, time: .shortened))"
        }
        
        return "\(home) contra \(away)\(timeString)"
    }
}

#Preview
{
    VStack(spacing: 16)
    {
        NBAGameCardView(game: Game(
            id: nil,
            homeTeam: "Cavaliers",
            awayTeam: "Knicks",
            date: Date(),
            competition: nil,
            broadcasters: ["SporTV", "Premiere", "YouTube (ESPN Brasil)", "YouTube (CazéTV)"],
            region: nil,
            sportType: "NBA",
            homeTeamColor: nil,
            awayTeamColor: nil
        ))
        
        NBAGameCardView(game: Game(
            id: nil,
            homeTeam: "Timberwolves",
            awayTeam: "Lakers",
            date: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
            competition: nil,
            broadcasters: ["Globo"],
            region: nil,
            sportType: "NBA",
            homeTeamColor: nil,
            awayTeamColor: nil
        ))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
