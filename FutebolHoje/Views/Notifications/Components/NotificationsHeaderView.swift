//
//  NotificationsHeaderView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import SwiftUI

struct NotificationsHeaderView: View
{
    let totalCount: Int
    
    var body: some View
    {
        HStack(spacing: 16)
        {
//            Image(systemName: "bell.badge.fill")
            Image(systemName: "bell.badge")
                .font(.system(size: 30))
//                .foregroundStyle(Color.AppTheme.primary)
//                .symbolRenderingMode(.hierarchical)
            
            VStack(alignment: .leading, spacing: 4)
            {
                Text("Notificações de Jogos")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                
                Text("Salve partidas para receber alertas com o horário e transmissão dos jogos.")
                    .font(.system(.body, design: .rounded))
//                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(statusText)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    private var statusText: String
    {
        if totalCount == 0
        {
            return "Nenhum jogo salvo ainda"
        }
        
        return "\(totalCount) jogo\(totalCount == 1 ? "" : "s") salvo\(totalCount == 1 ? "" : "s")"
    }
}

#Preview
{
    VStack(spacing: 20)
    {
        NotificationsHeaderView(totalCount: 0)
        NotificationsHeaderView(totalCount: 3)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
