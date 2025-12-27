//
//  CompetitionSelectorSheet.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 23/12/25.
//

import SwiftUI

struct CompetitionSelectorSheet: View
{
    @ObservedObject var viewModel: GamesViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            VStack(spacing: 8)
            {
                Text("Selecione as Competições")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                
                Text("Escolha de quais competições deseja ver os jogos")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 24)
            .padding(.horizontal)
            
            ScrollView
            {
                LazyVStack(spacing: 12)
                {
                    ForEach(viewModel.availableCompetitions, id: \.self)
                    { competition in
                        CompetitionCard(
                            competition: competition,
                            isSelected: viewModel.selectedCompetitions.contains(competition)
                        )
                        {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7))
                            {
                                viewModel.toggleCompetition(competition)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .overlay(
                VStack {
                    Spacer()
                    LinearGradient(
                        colors: [
                            Color(.systemGroupedBackground).opacity(0),
                            Color(.systemGroupedBackground).opacity(0.8),
                            Color(.systemGroupedBackground)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 40)
                    .allowsHitTesting(false)
                }
            )
            
            VStack(spacing: 0)
            {
//                Divider()
                
                Button(action: { dismiss() })
                {
                    Text("Concluído")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 40, style: .circular)
                                .fill(Color.AppTheme.tertiary)
                        )
                }
                .padding(.horizontal, 42)
                .padding(.vertical, 12)
            }
//            .background(Color(.systemBackground))
        }
        .background(Color(.systemGroupedBackground))
        .presentationDetents(dynamicDetents)
        .presentationDragIndicator(.visible)
    }
    
    private var dynamicDetents: Set<PresentationDetent>
    {
        let competitionCount = viewModel.availableCompetitions.count

        if competitionCount <= 3
        {
            return [.medium, .large]
        }
        else
        {
            return [.large]
        }
    }
}

fileprivate struct CompetitionCard: View
{
    let competition: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View
    {
        Button(action: action)
        {
            HStack(spacing: 16)
            {
                ZStack
                {
                    Circle()
                        .fill(isSelected ? Color.AppTheme.tertiary : Color(.systemGray5))
                        .frame(width: 28, height: 28)
                    
                    if isSelected
                    {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                
                Text(competition)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isSelected ? Color.AppTheme.tertiary.opacity(0.3) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview
{
    CompetitionSelectorSheet(viewModel: GamesViewModel())
}
