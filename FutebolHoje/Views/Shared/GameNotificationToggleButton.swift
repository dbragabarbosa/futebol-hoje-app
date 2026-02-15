//
//  GameNotificationToggleButton.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import SwiftUI

struct GameNotificationToggleButton: View
{
    let isActive: Bool
    let action: () -> Void
    
    var body: some View
    {
        Button(action: action)
        {
            Image(systemName: isActive ? "bell.fill" : "bell")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(isActive ? Color.white : Color.AppTheme.primary)
                .padding(8)
                .background(
                    Circle()
                        .fill(isActive ? Color.AppTheme.primary : Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.12), radius: 4, x: 0, y: 2)
                )
                .overlay(
                    Circle()
                        .stroke(Color.AppTheme.primary.opacity(isActive ? 0.0 : 0.2), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isActive ? "Notificação ativada" : "Ativar notificação")
    }
}

#Preview
{
    HStack(spacing: 12)
    {
        GameNotificationToggleButton(isActive: false, action: {})
        GameNotificationToggleButton(isActive: true, action: {})
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
