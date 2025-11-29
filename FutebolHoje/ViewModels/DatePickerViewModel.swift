//
//  DatePickerViewModel.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 28/11/25.
//

import Foundation
import UIKit
import Combine

class DatePickerViewModel: ObservableObject
{
    @Published var dateString: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init()
    {
        updateDate()
        setupNotifications()
    }
    
    private func setupNotifications()
    {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.updateDate()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
            .sink { [weak self] _ in
                self?.updateDate()
            }
            .store(in: &cancellables)
    }
    
    private func updateDate()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'de' MMMM"
        formatter.locale = Locale(identifier: "pt_BR")
        self.dateString = formatter.string(from: Date()).capitalized
    }
}
