//
//  GameCardView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 13/10/25.
//

import Foundation
import SwiftUI

struct GameCardView: View
{
    var body: some View
    {
        VStack(alignment: .center, spacing: 8)
        {
            Text("Campeonato Brasileiro")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack
            {
                Text("Flamengo")
                    .font(.headline)
                
                Spacer()
                
                VStack
                {
                    Text("16:00")
                        .font(.title3.bold())
                    
                    Text("SporTV, Premiere")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("Palmeiras")
                    .font(.headline)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

#Preview
{
    GameCardView()
}
