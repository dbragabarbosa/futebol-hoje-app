//
//  TabBarForLoweriOSVersions.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 04/12/25.
//

import SwiftUI

struct TabBarForLoweriOSVersions: View
{
    @Binding var activeTab: CustomTab
    
    var body: some View
    {
        HStack(spacing: 0)
        {
            ForEach(CustomTab.allCases, id: \.rawValue)
            { tab in
                Button
                {
                    activeTab = tab
                }
                label:
                {
                    VStack(spacing: 4)
                    {
                        Image(systemName: activeTab == tab ? tab.activeSymbol : tab.symbol)
                            .font(.title2)
                            .environment(\.symbolVariants, .none)
                        
                        Text(tab.rawValue)
                            .font(.caption2)
                            .fontWeight(activeTab == tab ? .bold : .regular)
                    }
                    .foregroundColor(activeTab == tab ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 50)
        .padding(.bottom, 4)
        .padding(.top, 4)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1),
            alignment: .top
        )
    }
}

#Preview
{
    TabBarForLoweriOSVersions(activeTab: .constant(.home))
}
