//
//  CompetitionFilterButtons.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 23/12/25.
//

import SwiftUI

struct CompetitionFilterButtons: View
{
    @ObservedObject var viewModel: GamesViewModel
    @Binding var showCompetitionSelector: Bool
    
    var body: some View
    {
        HStack(spacing: 12)
        {
            Button(action: { viewModel.selectAllCompetitions() })
            {
                Text("📋 Todas as competições")
                    .font(.system(size: 14, weight: viewModel.isAllCompetitionsSelected ? .bold : .medium))
                    .foregroundStyle(viewModel.isAllCompetitionsSelected ? .primary : .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(viewModel.isAllCompetitionsSelected ? Color.gray.opacity(0.1) : Color.clear)
                    )
                    .overlay(
                        Capsule()
                            .stroke(viewModel.isAllCompetitionsSelected ? Color.gray.opacity(0.6) : Color.clear, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            
            // "Selecionar competições" button
            Button(action: { showCompetitionSelector = true })
            {
                Text(customSelectionButtonText)
                    .font(.system(size: 14, weight: !viewModel.isAllCompetitionsSelected ? .bold : .medium))
                    .foregroundStyle(!viewModel.isAllCompetitionsSelected ? .primary : .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(!viewModel.isAllCompetitionsSelected ? Color.gray.opacity(0.1) : Color.clear)
                    )
                    .overlay(
                        Capsule()
                            .stroke(!viewModel.isAllCompetitionsSelected ? Color.gray.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
        .padding(.top, 8)
        .padding(.leading)
    }
    
    private var customSelectionButtonText: String
    {
        let count = viewModel.selectedCompetitions.count
        return count == 0 ? "Selecionar competições" : (count == 1 ? "1 selecionada" : "\(count) selecionadas")
    }
}

#Preview
{
    CompetitionFilterButtons(
        viewModel: GamesViewModel(),
        showCompetitionSelector: .constant(false)
    )
}
