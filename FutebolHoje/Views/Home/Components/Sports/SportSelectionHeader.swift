//
//  SportSelectionHeader.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 30/11/25.
//

import SwiftUI

struct SportSelectionHeader: View
{
    @Binding var selectedSport: SportType
    
    var body: some View
    {
        HStack(spacing: 20)
        {
            ForEach(SportType.allCases)
            { sport in
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2))
                    {
                        selectedSport = sport
                    }
                }) {
                    Text(sport.rawValue)
                        .font(.system(size: 16, weight: selectedSport == sport ? .bold : .medium))
                        .foregroundStyle(selectedSport == sport ? .primary : .secondary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            Capsule()
                                .fill(selectedSport == sport ? Color.AppTheme.tertiary.opacity(0.1) : Color.clear)
                        )
                        .overlay(
                            Capsule()
                                .stroke(selectedSport == sport ? Color.AppTheme.tertiary.opacity(0.9) : Color.clear, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 4)
        .padding(.horizontal)
        .padding(.bottom, 4)
    }
}

#Preview
{
    SportSelectionHeader(selectedSport: .constant(.futebol))
}
