//
//  TeamListView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 09/02/26.
//

import SwiftUI

struct NotificationsTeamListView: View
{
    @Binding var selectedTeam: BrazilianTeam?
    let onTeamSelected: (BrazilianTeam) -> Void
    
    var body: some View
    {
        LazyVStack(spacing: 12)
        {
            ForEach(BrazilianTeam.allCases)
            { team in
                TeamCard(
                    team: team,
                    isSelected: selectedTeam == team
                )
                {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7))
                    {
                        onTeamSelected(team)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

fileprivate struct TeamCard: View
{
    let team: BrazilianTeam
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View
    {
        Button(action: action)
        {
            HStack(spacing: 16)
            {
                Text(team.emoji)
                    .font(.title3)
                
                Text(team.displayName)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                ZStack
                {
                    Circle()
                        .fill(isSelected ? Color.AppTheme.secondary : Color(.systemGray5))
                        .frame(width: 28, height: 28)
                    
                    if isSelected
                    {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isSelected ? Color.AppTheme.secondary.opacity(0.2) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview
{
    ScrollView
    {
        NotificationsTeamListView(
            selectedTeam: .constant(.atleticoMineiro),
            onTeamSelected: { _ in }
        )
    }
}
