//
//  NotificationsView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 01/02/26.
//

import SwiftUI

struct NotificationsView: View
{
    @StateObject private var viewModel = NotificationsViewModel()
    private let analytics: AnalyticsService = FirebaseAnalyticsService.shared
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            NotificationsHeaderView()
            
            if !viewModel.notificationPermissionGranted
            {
                NotificationStatusRow(onActivateTapped: {
                    Task
                    {
                        await viewModel.requestNotificationPermission()
                    }
                })
            }
            
            ScrollView
            {
                NotificationsTeamListView(
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
    NotificationsView()
}
