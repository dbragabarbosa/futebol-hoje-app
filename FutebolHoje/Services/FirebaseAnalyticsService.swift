//
//  FirebaseAnalyticsService.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 11/01/26.
//

import Foundation
import FirebaseAnalytics

final class FirebaseAnalyticsService: AnalyticsService 
{
    static let shared = FirebaseAnalyticsService()
    
    private init() 
    {
        #if DEBUG
        print("🔍 FirebaseAnalyticsService initialized")
        #endif
    }
    
    func logEvent(_ event: AnalyticsEvent) 
    {
        let eventName = sanitizeEventName(event.name)
        let parameters = sanitizeParameters(event.parameters)
        
        Analytics.logEvent(eventName, parameters: parameters)
        
        #if DEBUG
        print("📊 Analytics Event: \(eventName)")
        if let params = parameters 
        {
            print("   Parameters: \(params)")
        }
        #endif
    }
    
    func setUserProperty(_ name: String, value: String?) 
    {
        let propertyName = sanitizePropertyName(name)
        Analytics.setUserProperty(value, forName: propertyName)
        
        #if DEBUG
        print("👤 User Property Set: \(propertyName) = \(value ?? "nil")")
        #endif
    }

    private func sanitizeEventName(_ name: String) -> String 
    {
        let sanitized = name
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .filter { $0.isLetter || $0.isNumber || $0 == "_" }
        
        return String(sanitized.prefix(40))
    }

    private func sanitizePropertyName(_ name: String) -> String 
    {
        let sanitized = name
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .filter { $0.isLetter || $0.isNumber || $0 == "_" }
        
        return String(sanitized.prefix(24))
    }

    private func sanitizeParameters(_ parameters: [String: Any]?) -> [String: Any]? 
    {
        guard let parameters = parameters else { return nil }
        
        var sanitized: [String: Any] = [:]
        
        for (key, value) in parameters 
        {
            let sanitizedKey = String(key.prefix(40))
            
            if let stringValue = value as? String 
            {
                sanitized[sanitizedKey] = String(stringValue.prefix(100))
            } 
            else 
            {
                sanitized[sanitizedKey] = value
            }
        }
        
        return sanitized.isEmpty ? nil : sanitized
    }
}