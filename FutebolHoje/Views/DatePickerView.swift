//
//  DatePickerView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 13/10/25.
//

import Foundation
import SwiftUI

struct DatePickerView: View
{
    var body: some View
    {
        // MARK: - Seletor de data (Ontem, Hoje, Amanhã)
        HStack
        {
            Button("Ontem") { /* ação futura */ }
            Spacer()
            Button("Domingo, 12 de outubro") { /* ação futura */ }
                .fontWeight(.semibold)
            Spacer()
            Button("Amanhã") { /* ação futura */ }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
}

#Preview
{
    DatePickerView()
}
