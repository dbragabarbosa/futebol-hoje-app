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
                VStack(spacing: 24)
                {
                    VStack(spacing: 8)
                    {
                        HStack
                        {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 40))
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
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                    VStack(spacing: 16)
                    {
                        ShareAppView()
                        RateAppView(viewModel: viewModel)
                        ContactDeveloperView(viewModel: viewModel)
                    }
                    .padding(.horizontal)
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
