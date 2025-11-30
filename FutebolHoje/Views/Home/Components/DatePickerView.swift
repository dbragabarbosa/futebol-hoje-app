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
    @StateObject private var viewModel = DatePickerViewModel()
    
    var body: some View
    {
        HStack
        {
            Spacer()
            
            Text(viewModel.dateString)
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
//                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
        .overlay
        {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        }
        .padding(.horizontal, 20)
        .accessibilityLabel("Data de hoje: \(viewModel.dateString)")
        .accessibilityAddTraits(.isStaticText)
        .background(Color(.systemBackground))
    }
}

#Preview
{
    DatePickerView()
        .padding()
}
