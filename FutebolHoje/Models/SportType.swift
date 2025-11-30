//
//  SportType.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 30/11/25.
//

import Foundation

enum SportType: String, CaseIterable, Identifiable
{
    case futebol = "⚽️ Futebol"
    case nfl = "🏈 NFL"
    case nba = "🏀 NBA"
    
    var id: String { self.rawValue }
}
