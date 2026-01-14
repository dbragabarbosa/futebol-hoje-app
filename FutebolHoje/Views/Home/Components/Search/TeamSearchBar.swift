//
//  TeamSearchBar.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 13/01/26.
//

import SwiftUI

struct TeamSearchBar: View
{
    @Binding var searchText: String
    @Binding var isFocused: Bool
    @FocusState private var internalIsFocused: Bool
    
    var body: some View
    {
        HStack(spacing: 8)
        {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.system(size: 14))
            
            TextField("Buscar time...", text: $searchText)
                .font(.system(size: 15))
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
                .focused($internalIsFocused)
                .onChange(of: internalIsFocused) { newValue in
                    isFocused = newValue
                }
            
            if !searchText.isEmpty
            {
                Button(action: {
                    searchText = ""
                    internalIsFocused = false
                })
                {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 14))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(internalIsFocused ? Color.AppTheme.tertiary.opacity(0.5) : Color.clear, lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
        .padding(.top, 4)
        .padding(.bottom, 4)
    }
}

#Preview
{
    VStack
    {
        TeamSearchBar(searchText: .constant(""), isFocused: .constant(false))
        TeamSearchBar(searchText: .constant("Real Madrid"), isFocused: .constant(false))
    }
    .padding()
}
