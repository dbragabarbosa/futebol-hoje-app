//
//  GamesView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 08/08/25.
//

import Foundation
import SwiftUI

//struct GamesView: View
//{
//    @StateObject private var viewModel = GamesViewModel()
//    
//    var body: some View
//    {
//        NavigationView
//        {
//            List(viewModel.games)
//            { game in
//                
//                VStack(alignment: .leading, spacing: 6)
//                {
//                    Text("\(game.homeTeam) x \(game.awayTeam)")
//                        .font(.headline)
//                    
//                    Text("Horário: \(game.date.formatted(date: .omitted, time: .shortened))")
//                        .font(.subheadline)
//                    
//                    Text("Transmissão: \(game.broadcaster)")
//                        .font(.footnote)
//                        .foregroundColor(.secondary)
//                }
//                .padding(.vertical, 4)
//            }
//            .navigationTitle("Futebol Hoje")
//        }
//    }
//}

struct GamesView: View
{
    var body: some View
    {
        VStack(spacing: 0)
        {
            HeaderView()
            
            DatePickerView()

            Divider()
            
            GamesListView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            
            Divider()
            
            TabsView()
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview
{
    GamesView()
}
