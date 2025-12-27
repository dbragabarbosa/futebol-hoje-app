//
//  FilterButtonByRegionView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 30/11/25.
//

import Foundation
import SwiftUI

struct FilterButtonByRegionView: View
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
                        .fill(isSelected ? Color.AppTheme.primary.opacity(0.1) : Color.clear)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.AppTheme.primary.opacity(0.7) : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
        .padding(.bottom, 4)
        .padding(.leading)
    }
}

#Preview
{
    FilterButtonByRegionView(title: "Brasil", isSelected: true, action: { })
}
