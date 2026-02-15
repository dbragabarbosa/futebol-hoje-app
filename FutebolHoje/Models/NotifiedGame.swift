//
//  NotifiedGame.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import Foundation

struct NotifiedGame: Identifiable, Codable, Equatable
{
    let id: String
    let sourceId: String?
    let homeTeam: String
    let awayTeam: String
    let date: Date
    let competition: String?
    let broadcasters: [String]?
    let sport: GameNotificationSport
    let createdAt: Date
    
    init?(game: Game, sport: GameNotificationSport)
    {
        guard let date = game.date else { return nil }
        
        self.sourceId = game.id
        self.homeTeam = game.homeTeam ?? "Time A"
        self.awayTeam = game.awayTeam ?? "Time B"
        self.date = date
        self.competition = game.competition
        self.broadcasters = game.broadcasters
        self.sport = sport
        self.createdAt = Date()
        self.id = Self.identifier(for: game, sport: sport)
    }
    
    func asGame() -> Game
    {
        Game(
            id: sourceId,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            date: date,
            competition: competition,
            broadcasters: broadcasters,
            region: nil,
            sportType: sport.displayName,
            homeTeamColor: nil,
            awayTeamColor: nil
        )
    }
    
    static func identifier(for game: Game, sport: GameNotificationSport) -> String
    {
        if let gameId = game.id, !gameId.isEmpty
        {
            return "\(sport.rawValue)_\(gameId)"
        }
        
        let timestamp = Int((game.date ?? Date.distantPast).timeIntervalSince1970)
        let home = normalized(game.homeTeam)
        let away = normalized(game.awayTeam)
        let competition = normalized(game.competition)
        
        return "\(sport.rawValue)_\(timestamp)_\(home)_\(away)_\(competition)"
    }
    
    private static func normalized(_ value: String?) -> String
    {
        let trimmed = (value ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty
        {
            return "na"
        }
        
        return trimmed
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "/", with: "_")
    }
}
