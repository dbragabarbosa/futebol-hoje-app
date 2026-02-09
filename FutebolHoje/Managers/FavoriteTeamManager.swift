//
//  FavoriteTeamManager.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 01/02/26.
//

import SwiftUI
import Combine

final class FavoriteTeamManager: ObservableObject
{
    @AppStorage("favoriteTeam") private var storedTeamRawValue: String = ""
    
    @Published private(set) var favoriteTeam: BrazilianTeam?
    
    private let analytics: AnalyticsService
    
    init(analytics: AnalyticsService = FirebaseAnalyticsService.shared)
    {
        self.analytics = analytics
        loadStoredTeam()
    }

    func setFavoriteTeam(_ team: BrazilianTeam)
    {
        favoriteTeam = team
        storedTeamRawValue = team.rawValue
        analytics.logEvent(.favoriteTeamSelected(team: team.rawValue))
    }
    
    func clearFavoriteTeam()
    {
        favoriteTeam = nil
        storedTeamRawValue = ""
        analytics.logEvent(.favoriteTeamCleared)
    }
    
    var hasFavoriteTeam: Bool
    {
        favoriteTeam != nil
    }
    
    private func loadStoredTeam()
    {
        guard !storedTeamRawValue.isEmpty else { return }
        favoriteTeam = BrazilianTeam(rawValue: storedTeamRawValue)
    }
}
