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
    
    var body: some View
    {
        VStack(spacing: 20)
        {
            HStack(spacing: 16)
            {
                ZStack
                {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 4)
                {
                    Text("Compartilhe")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Ajude a comunidade a crescer compartilhando o aplicativo!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            
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
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .foregroundStyle(.blue)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
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
