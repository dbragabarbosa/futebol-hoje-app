//
//  TabsView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 13/10/25.
//

import Foundation
import SwiftUI

struct TabsView: View
{
    @State var selectedTab = "Jogos"
    
    var body: some View
    {
        HStack
        {
            Spacer()
            
            Button(action: { selectedTab = "Jogos" })
            {
                VStack(spacing: 4)
                {
                    Image(systemName: "sportscourt.fill")
                        .font(.system(size: 20))
                    Text("Jogos")
                        .font(.system(size: 12))
                }
            }
            .foregroundColor(selectedTab == "Jogos" ? .blue : .gray)
            
            Spacer()
            
            Button(action: { selectedTab = "Notificações" })
            {
                VStack(spacing: 4)
                {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 20))
                    Text("Notificações")
                        .font(.system(size: 12))
                }
            }
            .foregroundColor(selectedTab == "Notificações" ? .blue : .gray)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
    }
}

#Preview
{
    TabsView()
}
