//
//  HeaderView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 13/10/25.
//

import Foundation
import SwiftUI

struct HeaderView: View
{
    var body: some View
    {
        HStack
        {
            Text("Futebol Hoje")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 12)
        .background(.ultraThinMaterial)
        .accessibilityLabel("Futebol Hoje")
        .accessibilityAddTraits(.isHeader)
    }
}

#Preview
{
    HeaderView()
}
