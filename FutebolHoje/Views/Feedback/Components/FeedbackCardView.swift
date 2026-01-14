//
//  FeedbackCardView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 24/12/25.
//

import SwiftUI

struct FeedbackCardView<Content: View>: View
{
    let gradientColors: [Color]
    let iconName: String
    let title: String
    let description: String
    let actionContent: () -> Content
    
    var body: some View
    {
        VStack(spacing: 14)
        {
            HStack(spacing: 10)
            {
                ZStack
                {
                    Circle()
                        .fill(.gray.opacity(0.9))
//                        .fill(
//                            LinearGradient(
//                                colors: gradientColors,
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 4)
                {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            
            actionContent()
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 6)
    }
}

#Preview
{
    ZStack
    {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        FeedbackCardView(
            gradientColors: [Color.AppTheme.secondary, Color.AppTheme.secondary],
            iconName: "star.fill",
            title: "Exemplo",
            description: "Esta é uma descrição de exemplo"
        ) {
            Button(action: {}) {
                HStack
                {
                    Text("Ação")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
//                .background(Color.AppTheme.secondary.opacity(0.1))
                .foregroundStyle(Color.AppTheme.secondary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.AppTheme.secondary.opacity(0.2), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}
