//
//  Game.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 05/08/25.
//

import Foundation
import FirebaseFirestore

struct Game: Identifiable, Codable
{
    @DocumentID var id: String?
    let homeTeam: String?
    let awayTeam: String?
    let date: Date?
    let hour: String?
    let broadcaster: String?
    let competition: String?
    let stage: String?
    let homeTeamColor: String?
    let awayTeamColor: String?
    let broadcasters: [String]?
}
