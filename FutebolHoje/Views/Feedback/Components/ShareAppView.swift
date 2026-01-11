//
//  ShareAppView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 28/11/25.
//

import SwiftUI

struct ShareAppView: View
{
    private let appLink = URL(string: "https://apps.apple.com/app/id6755705162")!
    private let analytics: AnalyticsService = FirebaseAnalyticsService.shared
    
    var body: some View
    {
        FeedbackCardView(
            gradientColors: [Color.AppTheme.secondary, Color.AppTheme.secondary],
            iconName: "square.and.arrow.up",
            title: "Compartilhe",
            description: "Ajude a comunidade a crescer compartilhando o aplicativo!"
        ) {
            ShareLink(item: appLink, message: Text("Confira o melhor app para acompanhar os jogos"))
            {
                HStack
                {
                    Text("Compartilhar App")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right")
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
            .onTapGesture {
                analytics.logEvent(.shareAppTapped)
            }
        }
    }
}

#Preview
{
    ZStack
    {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        ShareAppView()
            .padding()
    }
}
