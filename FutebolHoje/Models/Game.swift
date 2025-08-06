//
//  Game.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 05/08/25.
//

import Foundation

struct Game: Identifiable, Decodable
{
    let id: Int
    let homeTeam: String
    let awayTeam: String
    let date: Date
    let broadcaster: String
}
