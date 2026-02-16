//
//  NotificationTimingStore.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 16/02/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class NotificationTimingStore: ObservableObject
{
    @AppStorage("notificationTimingOptions") private var storedOptionsJSON: String = ""
    
    @Published private(set) var selectedOptions: Set<NotificationTimingOption> = [.atGameTime]
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init()
    {
        loadStoredOptions()
    }
    
    func toggle(_ option: NotificationTimingOption)
    {
        if selectedOptions.contains(option)
        {
            selectedOptions.remove(option)
        }
        else
        {
            selectedOptions.insert(option)
        }
        persist()
    }
    
    func isSelected(_ option: NotificationTimingOption) -> Bool
    {
        selectedOptions.contains(option)
    }
    
    private func loadStoredOptions()
    {
        guard !storedOptionsJSON.isEmpty else
        {
            selectedOptions = [.atGameTime]
            return
        }
        
        guard let data = storedOptionsJSON.data(using: .utf8) else
        {
            selectedOptions = [.atGameTime]
            storedOptionsJSON = ""
            return
        }
        
        do
        {
            let rawValues = try decoder.decode([String].self, from: data)
            let options = rawValues.compactMap(NotificationTimingOption.init)
            selectedOptions = Set(options)
        }
        catch
        {
            print("❌ Erro ao decodificar horarios de notificacao: \(error.localizedDescription)")
            selectedOptions = [.atGameTime]
            storedOptionsJSON = ""
        }
    }
    
    private func persist()
    {
        do
        {
            let rawValues = selectedOptions.map { $0.rawValue }
            let data = try encoder.encode(rawValues)
            storedOptionsJSON = String(data: data, encoding: .utf8) ?? ""
        }
        catch
        {
            print("❌ Erro ao salvar horarios de notificacao: \(error.localizedDescription)")
        }
    }
}
