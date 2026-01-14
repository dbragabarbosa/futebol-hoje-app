//
//  CustomTabBarView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 20/10/25.
//

import Foundation
import SwiftUI

struct CustomTabBarView: View
{
    @Binding var activeTab: CustomTab

    var body: some View
    {
        HStack(spacing: 10)
        {
            GeometryReader
            {
                CustomTabBar(size: $0.size, activeTab: $activeTab)
                { tab in
                    VStack(spacing: 3)
                    {
                        Image(systemName: tab.symbol)
                            .font(.title3)

//                        Text(tab.rawValue)
//                            .font(.system(size: 10))
//                            .fontWeight(.medium)
                    }
                    .symbolVariant(.fill)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 55)
        .padding(.horizontal, 20)
        .padding(.top, 4)
        .background(Color(.systemBackground))
    }
}

#Preview
{
    struct PreviewHost: View
    {
        @State var tab: CustomTab = .home
        
        var body: some View
        {
            CustomTabBarView(activeTab: $tab)
        }
    }
    
    return PreviewHost()
}
