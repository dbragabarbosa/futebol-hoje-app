//
//  NBAView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 30/11/25.
//

import SwiftUI

struct NBAView: View
{
    var body: some View
    {
        VStack(spacing: 16)
        {
            Image(systemName: "basketball.fill")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("Jogos da NBA")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Em breve você poderá acompanhar os jogos da NBA aqui.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview
{
    NBAView()
}
