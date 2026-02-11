//
//  HighlightsLinkView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 11/02/26.
//

import SwiftUI

struct HighlightsLinkView: View
{
    let url: URL

    var body: some View
    {
        Link(destination: url)
        {
            YouTubeLogo()
        }
        .accessibilityLabel("Abrir melhores momentos no YouTube")
    }
}

struct YouTubeLogo: View
{
    var size: CGFloat = 20
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: size * 0.15)
                .fill(Color.red)
                .frame(width: size, height: size * 0.7)
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
            
            Triangle()
                .fill(Color.white)
                .frame(width: size * 0.3, height: size * 0.35)
                .offset(x: size * 0.03)
        }
    }
}

struct Triangle: Shape
{
    func path(in rect: CGRect) -> Path
    {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

#Preview
{
    HighlightsLinkView(url: URL(string: "https://www.youtube.com")!)
        .padding()
        .background(Color(.systemGroupedBackground))
}

struct YouTubeLogo_Previews: PreviewProvider
{
    static var previews: some View
    {
        VStack(spacing: 40)
        {
            YouTubeLogo(size: 80)
            YouTubeLogo(size: 120)
            YouTubeLogo(size: 180)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
