//
//  FavoriteTeamsHeaderView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 09/02/26.
//

import SwiftUI

struct FavoriteTeamsHeaderView: View
{
    var body: some View
    {
        HStack(spacing: 16)
        {
            Image(systemName: "bell.badge")
                .font(.system(size: 27))
            
            VStack(alignment: .leading, spacing: 2)
            {
                Text("Escolha seu time favorito da Série A")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                
                Text("Receba notificações avisando quando e onde os jogos serão transmitidos")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

#Preview
{
    FavoriteTeamsHeaderView()
}
