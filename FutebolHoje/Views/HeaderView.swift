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
        VStack(alignment: .leading)
        {
            Text("Futebol Hoje")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }
}

#Preview
{
    HeaderView()
}
