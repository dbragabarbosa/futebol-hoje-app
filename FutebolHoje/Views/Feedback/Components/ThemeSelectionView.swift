//
//  ThemeSelectionView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 24/12/25.
//

import SwiftUI

struct ThemeSelectionView: View
{
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View
    {
        FeedbackCardView(
            gradientColors: [Color.AppTheme.secondary, Color.AppTheme.secondary],
            iconName: "light.max",
            title: "Aparência",
            description: "Escolha o tema de sua preferência."
        ) {
            HStack(spacing: 0)
            {
                ForEach(ThemeMode.allCases, id: \.self) { mode in
                    Button(action: {
                        withAnimation {
                            themeManager.setTheme(mode)
                        }
                    }) {
                        HStack(spacing: 4)
                        {
                            Image(systemName: mode.icon)
                                .font(.title3)
                            
                            Text(mode.displayName)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(
                            themeManager.selectedTheme == mode
                                ? Color.AppTheme.secondary.opacity(0.15)
                                : Color.clear
                        )
                        .foregroundStyle(
                            themeManager.selectedTheme == mode
                                ? Color.AppTheme.secondary
                                : Color.secondary
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    if mode != ThemeMode.allCases.last
                    {
                        Divider()
                            .frame(height: 14)
                    }
                }
            }
            .background(Color(.tertiarySystemGroupedBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

#Preview
{
    ZStack
    {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        ThemeSelectionView(themeManager: ThemeManager())
            .padding()
    }
}
