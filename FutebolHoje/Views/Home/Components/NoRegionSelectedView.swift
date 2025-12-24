//
//  NoRegionSelectedView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 30/11/25.
//

import SwiftUI

struct NoRegionSelectedView: View
{
    var body: some View
    {
        VStack(spacing: 24)
        {
            Spacer()
            
            ZStack
            {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "globe.americas.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
            }
            
            VStack(spacing: 12)
            {
                Text("Nenhuma região selecionada")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("Selecione Brasil ou Mundo acima para visualizar os jogos disponíveis.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview
{
    NoRegionSelectedView()
}
