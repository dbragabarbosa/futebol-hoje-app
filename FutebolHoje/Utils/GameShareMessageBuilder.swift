//
//  GameShareMessageBuilder.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 16/02/26.
//

import Foundation

enum GameShareMessageBuilder
{
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static func message(for game: Game) -> String
    {
        let home = trimmed(game.homeTeam, fallback: "Time A")
        let away = trimmed(game.awayTeam, fallback: "Time B")

        var lines: [String] = []

        let dateContext = game.date.flatMap { dateContextDescription(for: $0) }
        if let dateContext
        {
            lines.append("⚽️ Informações do jogo \(dateContext.titleSuffix)!")
        }
        else
        {
            lines.append("⚽️ Informações do jogo!")
        }
        
        lines.append("")
        
        lines.append("🆚 \(home) x \(away)")

        if let date = game.date
        {
            let dateLine = formattedDateLine(for: date, context: dateContext)
            lines.append("🗓️ \(dateLine)")
        }

        let competition = trimmed(game.competition, fallback: "")
        if !competition.isEmpty
        {
            lines.append("🏆 Competição: \(competition)")
        }

        if let broadcasters = game.broadcasters, !broadcasters.isEmpty
        {
            lines.append("📺 Transmissão: \(broadcasters.joined(separator: ", "))")
        }

//        let region = trimmed(game.region, fallback: "")
//        if !region.isEmpty
//        {
//            lines.append("🌍 Região: \(region)")
//        }
//
//        let sportType = trimmed(game.sportType, fallback: "")
//        if !sportType.isEmpty
//        {
//            lines.append("🏅 Esporte: \(sportType)")
//        }
        
        lines.append("")
        
        lines.append("📱 Informações do App Jogos do dia!")

        return lines.joined(separator: "\n")
    }

    private static func dateContextDescription(for date: Date) -> (titleSuffix: String, linePrefix: String)?
    {
        let calendar = Calendar.current
        if calendar.isDateInToday(date)
        {
            return ("de hoje", "Hoje")
        }
        if calendar.isDateInTomorrow(date)
        {
            return ("de amanhã", "Amanhã")
        }
        return ("do dia \(dateFormatter.string(from: date))", "")
    }

    private static func formattedDateLine(for date: Date, context: (titleSuffix: String, linePrefix: String)?) -> String
    {
        let dateString = dateFormatter.string(from: date)
        let timeString = timeFormatter.string(from: date)

        if let prefix = context?.linePrefix, !prefix.isEmpty
        {
            return "\(prefix), \(dateString), às \(timeString)"
        }
        return "\(dateString), às \(timeString)"
    }

    private static func trimmed(_ value: String?, fallback: String) -> String
    {
        let trimmedValue = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmedValue.isEmpty ? fallback : trimmedValue
    }
}
