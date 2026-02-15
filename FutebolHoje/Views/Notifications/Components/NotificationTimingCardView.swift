//
//  NotificationTimingCardView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import SwiftUI

struct NotificationTimingCardView: View
{
    var body: some View
    {
        HStack(spacing: 14)
        {
            Image(systemName: "clock.fill")
                .font(.title3)
                .foregroundStyle(Color.AppTheme.secondary)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.AppTheme.secondary.opacity(0.12))
                )
            
            VStack(alignment: .leading, spacing: 4)
            {
                Text("Horário das notificações")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Padrão atual: no horário do jogo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("Em breve")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.AppTheme.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.AppTheme.secondary.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
}

#Preview
{
    NotificationTimingCardView()
        .padding()
        .background(Color(.systemGroupedBackground))
}
