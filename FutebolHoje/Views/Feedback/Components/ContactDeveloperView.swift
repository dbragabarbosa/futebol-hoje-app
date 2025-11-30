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
        VStack(spacing: 20)
        {
            HStack(spacing: 16)
            {
                ZStack
                {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                VStack(alignment: .leading, spacing: 4)
                {
                    Text("Fale Conosco")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Problemas ou sugestões? Mande um email direto para quem constrói o app!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            
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
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .foregroundStyle(.purple)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
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
        
        ContactDeveloperView(viewModel: FeedbackViewModel())
            .padding()
    }
}
