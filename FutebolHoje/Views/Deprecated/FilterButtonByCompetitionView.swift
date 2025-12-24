//
//  FilterButtonByCompetitionView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 23/12/25.
//

import Foundation
import SwiftUI

struct FilterButtonByCompetitionView: View
{
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View
    {
        Button(action: action)
        {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview
{
    HStack(spacing: 12)
    {
        FilterButtonByCompetitionView(title: "Todas", isSelected: true, action: { })
        FilterButtonByCompetitionView(title: "Brasileirão", isSelected: false, action: { })
        FilterButtonByCompetitionView(title: "Copa do Brasil", isSelected: true, action: { })
    }
    .padding()
}
