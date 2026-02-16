//
//  NotificationTimingOption.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 16/02/26.
//

import Foundation

enum NotificationTimingOption: String, CaseIterable, Codable, Identifiable
{
    case atGameTime
    case minutes5Before
    case minutes15Before
    case minutes30Before
    case hour1Before
    case hours2Before
    case hours4Before
    case hours6Before
    case hours12Before
    case day1Before
    
    var id: String { rawValue }
    
    var title: String
    {
        switch self
        {
            case .atGameTime:
                return "Na hora do jogo"
            case .minutes5Before:
                return "5 minutos antes"
            case .minutes15Before:
                return "15 min antes"
            case .minutes30Before:
                return "30 min antes"
            case .hour1Before:
                return "1 hora antes"
            case .hours2Before:
                return "2 horas antes"
            case .hours4Before:
                return "4 horas antes"
            case .hours6Before:
                return "6 horas antes"
            case .hours12Before:
                return "12 horas antes"
            case .day1Before:
                return "24 horas antes"
        }
    }
    
    var shortTitle: String
    {
        switch self
        {
            case .atGameTime:
                return "Na hora"
            case .minutes5Before:
                return "5 min"
            case .minutes15Before:
                return "15 min"
            case .minutes30Before:
                return "30 min"
            case .hour1Before:
                return "1 hora"
            case .hours2Before:
                return "2 horas"
            case .hours4Before:
                return "4 horas"
            case .hours6Before:
                return "6 horas"
            case .hours12Before:
                return "12 horas"
            case .day1Before:
                return "24 horas"
        }
    }

    var notificationTitle: String
    {
        switch self
        {
            case .atGameTime:
                return "Jogo começando agora"
            case .minutes5Before:
                return "Jogo em 5 minutos"
            case .minutes15Before:
                return "Jogo em 15 minutos"
            case .minutes30Before:
                return "Jogo em 30 minutos"
            case .hour1Before:
                return "Jogo em 1 hora"
            case .hours2Before:
                return "Jogo em 2 horas"
            case .hours4Before:
                return "Jogo em 4 horas"
            case .hours6Before:
                return "Jogo em 6 horas"
            case .hours12Before:
                return "Jogo em 12 horas"
            case .day1Before:
                return "Jogo em 24 horas"
        }
    }
    
    var offset: TimeInterval
    {
        switch self
        {
            case .atGameTime:
                return 0
            case .minutes5Before:
                return -5 * 60
            case .minutes15Before:
                return -15 * 60
            case .minutes30Before:
                return -30 * 60
            case .hour1Before:
                return -60 * 60
            case .hours2Before:
                return -2 * 60 * 60
            case .hours4Before:
                return -4 * 60 * 60
            case .hours6Before:
                return -6 * 60 * 60
            case .hours12Before:
                return -12 * 60 * 60
            case .day1Before:
                return -24 * 60 * 60
        }
    }
    
    var sortOrder: Int
    {
        switch self
        {
            case .atGameTime:
                return 0
            case .minutes5Before:
                return 1
            case .minutes15Before:
                return 2
            case .minutes30Before:
                return 3
            case .hour1Before:
                return 4
            case .hours2Before:
                return 5
            case .hours4Before:
                return 6
            case .hours6Before:
                return 7
            case .hours12Before:
                return 8
            case .day1Before:
                return 9
        }
    }
}
