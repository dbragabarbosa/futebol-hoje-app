//
//  BrazilianTeam.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 01/02/26.
//

import Foundation

enum BrazilianTeam: String, CaseIterable, Codable, Identifiable
{
    case athleticoParanaense = "Athletico-PR"
    case atleticoMineiro = "Atlético-MG"
    case bahia = "Bahia"
    case botafogo = "Botafogo"
    case chapecoense = "Chapecoense"
    case corinthians = "Corinthians"
    case coritiba = "Coritiba"
    case cruzeiro = "Cruzeiro"
    case flamengo = "Flamengo"
    case fluminense = "Fluminense"
    case gremio = "Grêmio"
    case internacional = "Internacional"
    case mirassol = "Mirassol"
    case palmeiras = "Palmeiras"
    case redBullBragantino = "Red Bull Bragantino"
    case remo = "Remo"
    case santos = "Santos"
    case saoPaulo = "São Paulo"
    case vasco = "Vasco da Gama"
    case vitoria = "Vitória"
    
    var id: String { rawValue }
    
    var displayName: String { rawValue }
    
    var emoji: String
    {
        switch self
        {
            case .athleticoParanaense: return "🌪️"
            case .atleticoMineiro: return "🐔"
            case .bahia: return "🇳🇱"
            case .botafogo: return "⭐"
            case .chapecoense: return "🏹"
            case .corinthians: return "🦅"
            case .coritiba: return "🇳🇬"
            case .cruzeiro: return "🦊"
            case .flamengo: return "🔴"
            case .fluminense: return "🇭🇺"
            case .gremio: return "🇪🇪"
            case .internacional: return "🇦🇹"
            case .mirassol: return "🟡"
            case .palmeiras: return "🐷"
            case .redBullBragantino: return "🐂"
            case .remo: return "⚓"
            case .santos: return "🐳"
            case .saoPaulo: return "🇾🇪"
            case .vasco: return "💢"
            case .vitoria: return "🦁"
        }
    }
}
