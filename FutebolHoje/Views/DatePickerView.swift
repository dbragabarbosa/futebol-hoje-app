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
        HStack
        {
            Spacer()
            
            Text(todayString)
                .font(.headline)
                .foregroundColor(.accentColor)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
    
    private var todayString: String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'de' MMMM"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: Date()).capitalized
    }
}



#Preview
{
    DatePickerView()
}
