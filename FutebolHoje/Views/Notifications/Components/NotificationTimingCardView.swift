//
//  NotificationTimingCardView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 14/02/26.
//

import SwiftUI

struct NotificationTimingCardView: View
{
    @EnvironmentObject private var viewModel: GameNotificationsViewModel
    @State private var isExpanded: Bool = false
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 14)
        {
            Button
            {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9))
                {
                    isExpanded.toggle()
                }
            }
            label:
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
                        Text("Horários de notificação")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(subtitleText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
            
            if isExpanded
            {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10)
                {
                    ForEach(NotificationTimingOption.allCases.sorted { $0.sortOrder < $1.sortOrder })
                    { option in
                        timingButton(option)
                    }
                }
                
                if viewModel.selectedTimingOptions.isEmpty
                {
                    Text("Nenhum horário selecionado. Nenhuma notificação será enviada.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
    
    private func timingButton(_ option: NotificationTimingOption) -> some View
    {
        let isSelected = viewModel.isTimingSelected(option)
        
        return Button
        {
            viewModel.toggleTimingOption(option)
        }
        label:
        {
            HStack(spacing: 8)
            {
                Text(option.title)
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundStyle(isSelected ? Color.AppTheme.secondary : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                
                if isSelected
                {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(Color.AppTheme.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color.AppTheme.secondary.opacity(0.15) : Color(.tertiarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? Color.AppTheme.secondary.opacity(0.45) : Color.black.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var subtitleText: String
    {
        if viewModel.selectedTimingOptions.isEmpty
        {
            return "Selecione quando deseja receber os alertas"
        }
        
        if viewModel.selectedTimingOptions.count == 1,
           viewModel.selectedTimingOptions.contains(.atGameTime)
        {
            return "Padrão atual: na hora do jogo"
        }
        
        return "Selecionados: \(selectedSummary)"
    }
    
    private var selectedSummary: String
    {
        let sorted = viewModel.selectedTimingOptions.sorted { $0.sortOrder < $1.sortOrder }
        if sorted.count <= 3
        {
            return sorted.map { $0.shortTitle }.joined(separator: ", ")
        }
        
        return "\(sorted.count) horários selecionados"
    }
}

#Preview
{
    NotificationTimingCardView()
        .padding()
        .background(Color(.systemGroupedBackground))
        .environmentObject(GameNotificationsViewModel())
}
