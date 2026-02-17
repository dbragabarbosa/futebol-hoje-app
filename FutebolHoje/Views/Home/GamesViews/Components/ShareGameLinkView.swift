//
//  ShareGameLinkView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 16/02/26.
//

import SwiftUI

struct ShareGameLinkView: View
{
    let game: Game
    var size: CGFloat = 20

    private let analytics: AnalyticsService = FirebaseAnalyticsService.shared

    var body: some View
    {
        ShareLink(item: shareMessage)
        {
            ShareGameIcon(size: size)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Compartilhar jogo")
        .onTapGesture {
            analytics.logEvent(.shareGameTapped(gameId: game.id))
        }
    }

    private var shareMessage: String
    {
        GameShareMessageBuilder.message(for: game)
    }
}

struct ShareGameIcon: View
{
    var size: CGFloat = 20

    var body: some View
    {
        Image(systemName: "square.and.arrow.up")
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(Color.AppTheme.secondary)
    }
}

#Preview
{
    ShareGameLinkView(game: Game(
        id: "preview",
        homeTeam: "Galo",
        awayTeam: "Palmeiras",
        date: Date(),
        competition: "Campeonato Brasileiro",
        broadcasters: ["SporTV"],
        region: "Brasil",
        sportType: nil,
        homeTeamColor: nil,
        awayTeamColor: nil
    ))
    .padding()
    .background(Color(.systemGroupedBackground))
}
