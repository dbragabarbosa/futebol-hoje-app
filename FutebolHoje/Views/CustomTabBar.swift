//
//  CustomTabBar.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 15/10/25.
//

import Foundation
import SwiftUI

struct CustomTabBar<TabItemView: View>: UIViewRepresentable
{
    var size: CGSize
    var activeTint: Color = .blue
    var barTint: Color = .gray.opacity(0.15)
    @Binding var activeTab: CustomTab
    @ViewBuilder var tabItemView: (CustomTab) -> TabItemView
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UISegmentedControl
    {
        let items = CustomTab.allCases.map(\.rawValue)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = activeTab.index
        
        // Converting Tab Item View into an image
        for (index, tab) in CustomTab.allCases.enumerated()
        {
            let renderer = ImageRenderer(content: tabItemView(tab))
            renderer.scale = 2 // 2 is enough
            let image = renderer.uiImage
            
            control.setImage(image, forSegmentAt: index)
        }
        
        DispatchQueue.main.async {
            for subview in control.subviews
            {
                if subview is UIImageView && subview != control.subviews.last
                {
                    subview.alpha = 0 // It's a background Image View
                }
            }
        }
        
        control.selectedSegmentTintColor = UIColor(barTint)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(activeTint)
        ], for: .selected)
        
        control.addTarget(context.coordinator, action: #selector(context.coordinator.tabSelected(_:)), for: .valueChanged)
        return control
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context)
    {
        
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize?
    {
        return size
    }
    
    class Coordinator: NSObject
    {
        var parent: CustomTabBar
        init(parent: CustomTabBar) {
            self.parent = parent
        }
        
        @objc func tabSelected(_ control: UISegmentedControl)
        {
            parent.activeTab = CustomTab.allCases[control.selectedSegmentIndex]
        }
    }
}
