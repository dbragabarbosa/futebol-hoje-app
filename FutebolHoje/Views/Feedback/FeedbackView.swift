//
//  ReviewView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 28/11/25.
//

import SwiftUI

struct FeedbackView: View
{
    @StateObject private var viewModel = FeedbackViewModel()
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                VStack(spacing: 8)
                {
                    VStack(spacing: 8)
                    {
                        HStack
                        {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.pink)
                            
                            Text("Queremos ouvir você!")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                        
                        Text("Sua opinião nos ajuda a melhorar cada vez mais.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                    VStack(spacing: 12)
                    {
                        ShareAppView()
                        RateAppView(viewModel: viewModel)
                        ContactDeveloperView(viewModel: viewModel)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview
{
    FeedbackView()
}
