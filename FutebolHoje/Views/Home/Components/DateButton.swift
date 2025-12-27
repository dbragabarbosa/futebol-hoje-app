//
//  DateButton.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 25/12/25.
//

import SwiftUI

struct DateButton: View
{
    let title: String
    let isSelected: Bool
    var expands: Bool = true
    let action: () -> Void
    
    var body: some View
    {
        Button(action: action)
        {
            Text(title)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundColor(isSelected ? Color(uiColor: .label) : Color(uiColor: .secondaryLabel))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: expands ? .infinity : nil)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(backgroundView)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
    
    @ViewBuilder
    private var backgroundView: some View
    {
        if isSelected
        {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
                .overlay
                {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                }
        }
        else
        {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.1)) // Subtle background for unselected, or clear if preferred
        }
    }
}

#Preview
{
    HStack
    {
        DateButton(title: "Today", isSelected: true, action: {})
        DateButton(title: "Tomorrow", isSelected: false, action: {})
    }
    .padding()
}

#Preview
{
    HStack
    {
        DateButton(title: "Today", isSelected: true, action: {})
        DateButton(title: "Tomorrow", isSelected: false, action: {})
    }
    .padding()
    .background(Color.black) // Dark background to see the glass effect
}
