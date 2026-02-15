//
//  FavoriteTeamsView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 01/02/26.
//

import SwiftUI

struct FavoriteTeamsView: View
{
    @StateObject private var viewModel = FavoriteTeamsViewModel()
    private let analytics: AnalyticsService = FirebaseAnalyticsService.shared
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            FavoriteTeamsHeaderView()
            
            if !viewModel.notificationPermissionGranted
            {
                NotificationPermissionStatusRow(onActivateTapped: {
                    Task
                    {
                        await viewModel.requestNotificationPermission()
                    }
                })
            }
            
            ScrollView
            {
                FavoriteTeamsListView(
                    selectedTeam: $viewModel.selectedTeam,
                    onTeamSelected: { team in
                        viewModel.selectTeam(team)
                    }
                )
                .padding(.top, 12)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear
        {
            analytics.logScreenView("Notifications")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification))
        { _ in
            viewModel.checkNotificationPermission()
        }
    }
}

#Preview
{
    FavoriteTeamsView()
}
