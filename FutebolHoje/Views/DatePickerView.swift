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
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundStyle(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background
        {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
        .overlay
        {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        }
        .padding(.horizontal, 20)
        .accessibilityLabel("Data de hoje: \(todayString)")
        .accessibilityAddTraits(.isStaticText)
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
        .previewLayout(.sizeThatFits)
        .padding()
}
