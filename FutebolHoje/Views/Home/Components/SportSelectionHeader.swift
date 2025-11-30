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
                                .fill(selectedSport == sport ? Color.blue.opacity(0.1) : Color.clear)
                        )
                        .overlay(
                            Capsule()
                                .stroke(selectedSport == sport ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

#Preview
{
    SportSelectionHeader(selectedSport: .constant(.futebol))
}
