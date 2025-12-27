//
//  ErrorView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 27/12/25.
//

import SwiftUI

struct ErrorView: View
{
    let message: String
    let action: (() -> Void)?
    
    var body: some View
    {
        VStack(spacing: 20)
        {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            
            Text(message)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            if let action = action
            {
                Button(action: action)
                {
                    HStack
                    {
                        Image(systemName: "arrow.clockwise")
                        Text("Tentar Novamente")
                    }
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Erro: \(message). Botão tentar novamente")
    }
}

#Preview("Erro ao processar")
{
    ErrorView(message: "Erro ao processar dados dos jogos.", action: nil)
}

#Preview("Erro ao carregar")
{
    ErrorView(message: "Erro ao carregar jogos. Tente novamente.", action: nil)
}
