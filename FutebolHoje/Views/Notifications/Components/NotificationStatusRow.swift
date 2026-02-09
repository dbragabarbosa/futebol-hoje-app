//
//  NotificationStatusRow.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 09/02/26.
//

import SwiftUI

struct NotificationStatusRow: View
{
    let onActivateTapped: () -> Void
    
    var body: some View
    {
        HStack(spacing: 12)
        {
            Image(systemName: "bell.slash")
                .font(.title3)
                .foregroundColor(Color.AppTheme.tertiary)
            
            VStack(alignment: .leading, spacing: 2)
            {
                Text("Notificações desativadas")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("Ative para receber alertas")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Ativar", action: onActivateTapped)
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .tint(Color.AppTheme.tertiary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview
{
    NotificationStatusRow(onActivateTapped: {})
}
