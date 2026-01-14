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
    case nba = "🏀 NBA"
//    case nfl = "🏈 NFL"
    
    var id: String { self.rawValue }
}
