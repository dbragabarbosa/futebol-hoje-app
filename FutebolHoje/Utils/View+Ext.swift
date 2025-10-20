//
//  View+Ext.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 20/10/25.
//

import Foundation
import SwiftUI

/// Blur Fade In/Out
extension View
{
    @ViewBuilder
    func blurFade(_ status: Bool) -> some View
    {
        self
            .compositingGroup()
            .blur(radius: status ? 0 : 10)
            .opacity(status ? 1 : 0)
    }
}
