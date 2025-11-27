//
//  CustomTabBarCoordinator.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 26/11/25.
//

import Foundation
import SwiftUI

final class CustomTabBarCoordinator: NSObject
{
    var activeTab: Binding<CustomTab>
    
    init(activeTab: Binding<CustomTab>)
    {
        self.activeTab = activeTab
    }
    
    @objc func tabSelected(_ control: UISegmentedControl)
    {
        activeTab.wrappedValue = CustomTab.allCases[control.selectedSegmentIndex]
    }
}
