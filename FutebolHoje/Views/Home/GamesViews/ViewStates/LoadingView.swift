//
//  LoadingView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 27/12/25.
//

import SwiftUI

struct LoadingView: View
{
    var body: some View
    {
        VStack(spacing: 16)
        {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Carregando jogos...")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .accessibilityLabel("Carregando jogos")
    }
}

#Preview {
    LoadingView()
}
