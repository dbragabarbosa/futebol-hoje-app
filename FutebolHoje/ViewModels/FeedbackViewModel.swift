//
//  ReviewViewModel.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 28/11/25.
//

import Foundation
import UIKit
import Combine

class FeedbackViewModel: ObservableObject
{
    var objectWillChange: ObservableObjectPublisher? { nil }
    
    private let appStoreId = "6755705162"
    
    private let contactEmail = "bulbs-grange0h@icloud.com"
    
    func rateApp()
    {
        guard let url = URL(string: "https://apps.apple.com/app/id\(appStoreId)?action=write-review") else { return }
        
        if UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openEmail()
    {
        let subject = "Contato - Futebol Hoje"
        let body = "Olá, gostaria de falar sobre ..."
        
        guard let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "mailto:\(contactEmail)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        else { return }
        
        if UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
