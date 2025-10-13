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
    var body: some View
    {
        @State var selectedTab = 0 // 0 = Jogos, 1 = Notificações
        
        // MARK: - Barra inferior (Tabs)
        HStack
        {
            Button(action: { selectedTab = 0 })
            {
                VStack
                {
                    Image(systemName: "sportscourt.fill")
                    Text("Jogos")
                }
            }
            .foregroundColor(selectedTab == 0 ? .blue : .gray)
            
            Spacer()
            
            Button(action: { selectedTab = 1 })
            {
                VStack
                {
                    Image(systemName: "bell.fill")
                    Text("Notificações")
                }
            }
            .foregroundColor(selectedTab == 1 ? .blue : .gray)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

#Preview
{
    TabsView()
}
