//
//  YouTubeHighlights.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 11/02/26.
//

import Foundation

enum YouTubeHighlights
{
    enum Sport
    {
        case futebol
        case nba
    }

    static func searchURL(homeTeam: String?, awayTeam: String?, competition: String?, sport: Sport) -> URL?
    {
        let home = trimmed(homeTeam)
        let away = trimmed(awayTeam)

        guard !home.isEmpty, !away.isEmpty else { return nil }

        var query = ""
        switch sport
        {
            case .futebol:
                query = "\(home) x \(away) melhores momentos"
                let competition = trimmed(competition)
                if !competition.isEmpty
                {
                    query += " \(competition)"
                }
            case .nba:
                query = "\(home) vs \(away) highlights"
        }

        var components = URLComponents(string: "https://www.youtube.com/results")
        components?.queryItems = [
            URLQueryItem(name: "search_query", value: query)
        ]
        return components?.url
    }

    static func isLikelyFinished(date: Date?, sport: Sport) -> Bool
    {
        guard let date else { return false }
        let cutoff = Date().addingTimeInterval(-graceSeconds(for: sport))
        return date <= cutoff
    }

    private static func graceSeconds(for sport: Sport) -> TimeInterval
    {
        switch sport
        {
            case .futebol:
                return 2 * 60 * 60 + 15 * 60
            case .nba:
                return 3 * 60 * 60
        }
    }

    private static func trimmed(_ value: String?) -> String
    {
        value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}

