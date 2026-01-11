//
//  AnalyticsService.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 11/01/26.
//

import Foundation

protocol AnalyticsService 
{
    func logEvent(_ event: AnalyticsEvent)

    func logScreenView(_ screenName: String)

    func setUserProperty(_ name: String, value: String?)
}

extension AnalyticsService 
{
    func logScreenView(_ screenName: String) 
    {
        logEvent(.screenViewed(screenName: screenName))
    }
}
