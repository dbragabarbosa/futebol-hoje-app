//
//  AnalyticsEvent.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 11/01/26.
//

import Foundation

enum AnalyticsEvent 
{
    case sportSelected(SportType)
    case dateFilterChanged(Date)
    case regionFilterChanged(Set<String>)
    case competitionFilterChanged(competition: String, isSelected: Bool)
    case allCompetitionsSelected
    
    case tabChanged(CustomTab)
    case screenViewed(screenName: String)
    
    case gameCardTapped(gameId: String)
    case shareAppTapped
    case rateAppTapped
    case contactDeveloperTapped
    
    case themeChanged(ThemeMode)
    
    case error(message: String, context: String)
    case networkError(context: String)
    
    var name: String 
    {
        switch self 
        {
            case .sportSelected:
                return "sport_selected"
            case .dateFilterChanged:
                return "date_filter_changed"
            case .regionFilterChanged:
                return "region_filter_changed"
            case .competitionFilterChanged:
                return "competition_filter_changed"
            case .allCompetitionsSelected:
                return "all_competitions_selected"
            case .tabChanged:
                return "tab_changed"
            case .screenViewed:
                return "screen_view"
            case .gameCardTapped:
                return "game_card_tapped"
            case .shareAppTapped:
                return "share_app_tapped"
            case .rateAppTapped:
                return "rate_app_tapped"
            case .contactDeveloperTapped:
                return "contact_developer_tapped"
            case .themeChanged:
                return "theme_changed"
            case .error:
                return "app_error"
            case .networkError:
                return "network_error"
        }
    }
    
    var parameters: [String: Any]? 
    {
        switch self 
        {
            case .sportSelected(let sport):
                return ["sport": sport.rawValue]
                
            case .dateFilterChanged(let date):
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let isToday = Calendar.current.isDateInToday(date)
                let isTomorrow = Calendar.current.isDateInTomorrow(date)
                
                var params: [String: Any] = ["date": formatter.string(from: date)]
                if isToday {
                    params["date_type"] = "today"
                } else if isTomorrow {
                    params["date_type"] = "tomorrow"
                } else {
                    params["date_type"] = "custom"
                }
                return params
                
            case .regionFilterChanged(let regions):
                return [
                    "regions": regions.sorted().joined(separator: ", "),
                    "region_count": regions.count
                ]
                
            case .competitionFilterChanged(let competition, let isSelected):
                return [
                    "competition": competition,
                    "action": isSelected ? "selected" : "deselected"
                ]
                
            case .allCompetitionsSelected:
                return nil
                
            case .tabChanged(let tab):
                return ["tab": tab.rawValue]
                
            case .screenViewed(let screenName):
                return [
                    "screen_name": screenName,
                    "screen_class": screenName
                ]
                
            case .gameCardTapped(let gameId):
                return ["game_id": gameId]
                
            case .shareAppTapped, .rateAppTapped, .contactDeveloperTapped:
                return nil
                
            case .themeChanged(let theme):
                return ["theme": theme.rawValue]
                
            case .error(let message, let context):
                return [
                    "error_message": message,
                    "context": context
                ]
                
            case .networkError(let context):
                return ["context": context]
        }
    }
}