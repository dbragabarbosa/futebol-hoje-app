//
//  ReviewView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 28/11/25.
//

import SwiftUI
import UIKit

struct FeedbackView: View
{
    @StateObject private var viewModel = FeedbackViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                VStack(spacing: 8)
                {
                    VStack(spacing: 8)
                    {
                        AppHeaderView()
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                    VStack(spacing: 12)
                    {
                        ShareAppView()
                        RateAppView(viewModel: viewModel)
                        ContactDeveloperView(viewModel: viewModel)
                        ThemeSelectionView(themeManager: themeManager)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
        .navigationViewStyle(.stack)
    }
}

private struct AppHeaderView: View {
    private var appName: String {
        if let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String, !displayName.isEmpty {
            return displayName
        }
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    }
    
    private var appIcon: UIImage? {
        guard
            let info = Bundle.main.infoDictionary,
            let icons = info["CFBundleIcons"] as? [String: Any],
            let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let files = primary["CFBundleIconFiles"] as? [String],
            let last = files.last,
            let image = UIImage(named: last)
        else {
            return nil
        }
        return image
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if let icon = appIcon {
                Image(uiImage: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .cornerRadius(14)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            Text(appName)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
}

#Preview
{
    let manager = ThemeManager()
    manager.setTheme(.light)
    
    return FeedbackView()
        .environmentObject(manager)
}
