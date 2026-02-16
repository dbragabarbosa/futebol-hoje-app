//
//  NotificationsView.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 01/02/26.
//

import SwiftUI

struct NotificationsView: View
{
    @EnvironmentObject private var viewModel: GameNotificationsViewModel
    private let analytics: AnalyticsService = FirebaseAnalyticsService.shared
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            NotificationsHeaderView(totalCount: viewModel.games.count)
            
            if !viewModel.notificationPermissionGranted
            {
                NotificationPermissionStatusRow(onActivateTapped: {
                    viewModel.handlePermissionCTA()
                })
            }
            
            ScrollView
            {
                LazyVStack(spacing: 12)
                {
                    NotificationTimingCardView()
                    
                    if viewModel.games.isEmpty
                    {
                        ContentUnavailableView(
                            icon: "bell.slash",
                            title: "Nenhum Jogo Salvo",
                            message: "Marque partidas na tela de jogos para ver a lista dos selecionados aqui.",
                            buttonTitle: nil,
                            action: nil
                        )
                    }
                    else
                    {
                        ForEach(viewModel.games)
                        { game in
                            notificationCard(for: game)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
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
    
    @ViewBuilder
    private func notificationCard(for game: NotifiedGame) -> some View
    {
        switch game.sport
        {
            case .futebol:
                GameCardView(game: game.asGame())
            case .nba:
                NBAGameCardView(game: game.asGame())
        }
    }
}

#Preview
{
    NotificationsView()
        .environmentObject(GameNotificationsViewModel())
}
