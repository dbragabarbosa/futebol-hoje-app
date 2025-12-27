//
//  NBADatePickerView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 27/12/25.
//

import Foundation
import SwiftUI

struct NBADatePickerView: View
{
    @ObservedObject var viewModel: NBAGamesViewModel
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'de' MMMM"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()
    
    var body: some View
    {
        HStack(spacing: 8)
        {
            DateButton(
                title: todayString,
                isSelected: Calendar.current.isDateInToday(viewModel.selectedDate)
            ) {
                viewModel.selectToday()
            }
            
            DateButton(
                title: "Amanhã",
                isSelected: Calendar.current.isDateInTomorrow(viewModel.selectedDate),
                expands: false
            ) {
                viewModel.selectTomorrow()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 4)
        .padding(.bottom, 6)
        .background(Color(.systemBackground))
    }
    
    private var todayString: String
    {
        return Self.dateFormatter.string(from: Date()).capitalized
    }
}

#Preview
{
    NBADatePickerView(viewModel: NBAGamesViewModel())
}
