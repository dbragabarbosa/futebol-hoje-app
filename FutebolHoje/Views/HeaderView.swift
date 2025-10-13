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
        // MARK: - Cabeçalho com título
        VStack(alignment: .leading, spacing: 4)
        {
            Text("Futebol Hoje")
                .font(.largeTitle.bold())
            
//                Text("Domingo, 12 de outubro")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    .padding(.top, 2)
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
}

#Preview
{
    HeaderView()
}
