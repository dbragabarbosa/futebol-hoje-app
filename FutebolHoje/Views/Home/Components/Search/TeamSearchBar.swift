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
    @FocusState private var isFocused: Bool
    
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
                .focused($isFocused)
            
            if !searchText.isEmpty
            {
                Button(action: {
                    searchText = ""
                    isFocused = false
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
                .stroke(isFocused ? Color.AppTheme.tertiary.opacity(0.5) : Color.clear, lineWidth: 1.5)
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
        TeamSearchBar(searchText: .constant(""))
        TeamSearchBar(searchText: .constant("Real Madrid"))
    }
    .padding()
}
