//
//  RateAppView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 28/11/25.
//

import SwiftUI

struct RateAppView: View
{
    @ObservedObject var viewModel: FeedbackViewModel
    
    var body: some View
    {
        FeedbackCardView(
            gradientColors: [Color.AppTheme.secondary, Color.AppTheme.secondary],
            iconName: "star.fill",
            title: "Avaliar na App Store",
            description: "Leva menos de um minuto!"
        ) {
            Button(action: {
                viewModel.rateApp()
            }) {
                HStack
                {
                    Text("Avaliar Agora")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: "star.circle.fill")
                        .font(.headline)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(Color.AppTheme.secondary.opacity(0.10))
                .foregroundStyle(Color.AppTheme.secondary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.AppTheme.secondary.opacity(0.3), lineWidth: 1)
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
        
        RateAppView(viewModel: FeedbackViewModel())
            .padding()
    }
}
