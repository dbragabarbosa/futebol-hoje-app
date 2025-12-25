//
//  ContactDeveloperView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 28/11/25.
//

import SwiftUI

struct ContactDeveloperView: View
{
    @ObservedObject var viewModel: FeedbackViewModel
    
    var body: some View
    {
        FeedbackCardView(
//                    gradientColors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                    gradientColors: [Color.AppTheme.secondary, Color.AppTheme.secondary],
                    iconName: "envelope.fill",
                    title: "Fale Conosco",
                    description: "Problemas ou sugestões? Mande um email direto para quem constrói o app!"
                ) {
            Button(action: {
                viewModel.openEmail()
            }) {
                HStack
                {
                    Text("Enviar Email")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: "paperplane.fill")
                        .font(.headline)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(Color.AppTheme.secondary.opacity(0.1))
                .foregroundStyle(Color.AppTheme.secondary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.AppTheme.secondary.opacity(0.2), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview
{
    ZStack
    {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        ContactDeveloperView(viewModel: FeedbackViewModel())
            .padding()
    }
}
