//
//  GameNotificationsStore.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class GameNotificationsStore: ObservableObject
{
    @AppStorage("notifiedGames") private var storedGamesJSON: String = ""
    
    @Published private(set) var games: [NotifiedGame] = []
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init()
    {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
        
        loadStoredGames()
        sortGames()
    }
    
    func contains(game: Game, sport: GameNotificationSport) -> Bool
    {
        let identifier = NotifiedGame.identifier(for: game, sport: sport)
        return games.contains { $0.id == identifier }
    }
    
    func contains(id: String) -> Bool
    {
        games.contains { $0.id == id }
    }
    
    func upsert(_ game: NotifiedGame)
    {
        if let index = games.firstIndex(where: { $0.id == game.id })
        {
            games[index] = game
        }
        else
        {
            games.append(game)
        }
        sortGames()
        persistGames()
    }
    
    @discardableResult
    func remove(id: String) -> NotifiedGame?
    {
        guard let index = games.firstIndex(where: { $0.id == id }) else { return nil }
        let removed = games.remove(at: index)
        persistGames()
        return removed
    }
    
    @discardableResult
    func removeExpiredGames(referenceDate: Date = Date()) -> [NotifiedGame]
    {
        let (validGames, expiredGames) = games.partitioned { $0.date >= referenceDate }
        
        if !expiredGames.isEmpty
        {
            games = validGames
            persistGames()
        }
        
        return expiredGames
    }
    
    private func loadStoredGames()
    {
        guard !storedGamesJSON.isEmpty else { return }
        guard let data = storedGamesJSON.data(using: .utf8) else { return }
        
        do
        {
            games = try decoder.decode([NotifiedGame].self, from: data)
        }
        catch
        {
            print("❌ Erro ao decodificar jogos notificados: \(error.localizedDescription)")
            games = []
            storedGamesJSON = ""
        }
    }
    
    private func persistGames()
    {
        do
        {
            let data = try encoder.encode(games)
            storedGamesJSON = String(data: data, encoding: .utf8) ?? ""
        }
        catch
        {
            print("❌ Erro ao salvar jogos notificados: \(error.localizedDescription)")
        }
    }
    
    private func sortGames()
    {
        games.sort { $0.date < $1.date }
    }
}

private extension Array
{
    func partitioned(by isIncluded: (Element) -> Bool) -> ([Element], [Element])
    {
        var included: [Element] = []
        var excluded: [Element] = []
        
        for element in self
        {
            if isIncluded(element)
            {
                included.append(element)
            }
            else
            {
                excluded.append(element)
            }
        }
        
        return (included, excluded)
    }
}
