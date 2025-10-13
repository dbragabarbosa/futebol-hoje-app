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
    let homeTeam: String
    let awayTeam: String
    let date: Date
    let broadcaster: String
}
