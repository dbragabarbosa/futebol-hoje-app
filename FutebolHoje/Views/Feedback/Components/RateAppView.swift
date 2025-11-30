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
        VStack(spacing: 20)
        {
            HStack(spacing: 16)
            {
                ZStack
                {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 4)
                {
                    Text("Avaliar na App Store")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Leva apenas um minuto!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            
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
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.yellow.opacity(0.15))
                .foregroundStyle(.orange)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
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
        
        RateAppView(viewModel: FeedbackViewModel())
            .padding()
    }
}
