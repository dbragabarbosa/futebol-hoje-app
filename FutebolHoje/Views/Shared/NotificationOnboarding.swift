//
//  NotificationOnboarding.swift
//  FutebolHoje
//
//  Created by Daniel Braga Barbosa on 15/02/26.
//

import SwiftUI

struct NotificationOnboardingConfig
{
    var title: String
    var content: String

    var notificationTitle: String
    var notificationContent: String

    var primaryButtonTitle: String
    var secondaryButtonTitle: String
}

struct NotificationOnboarding<NotificationLogo: View>: View
{
    var config: NotificationOnboardingConfig
    var permissionStatus: NotificationPermissionStatus
    
    @ViewBuilder var notificationLogo: NotificationLogo
    
    var onPrimaryButtonTap: () -> ()
    var onSecondaryButtonTap: () -> ()
    
    @State private var animateNotification: Bool = false
    @State private var loopContinues: Bool = true
    @State private var askPermission: Bool = false
    @State private var showArrow: Bool = false
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View
    {
        ZStack
        {
            ZStack
            {
                Rectangle()
                    .fill(backgroundColor)
                    .ignoresSafeArea()
                    .blurOpacity(askPermission)
                
                Image(systemName: "arrow.up")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundStyle(foregroundColor)
                    .offset(x: isiOS26 ? 75 : 70, y: 150)
                    .blurOpacity(showArrow)
            }
            .allowsHitTesting(false)
            
            VStack(spacing: 0)
            {
                iPhonePreview()
                    .padding(.top, 15)
                
                VStack(spacing: 20)
                {
                    Text(config.title)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(config.content)
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer(minLength: 0)
                    
                    Button
                    {
                        handlePrimaryButtonTap()
                    }
                    label:
                    {
                        Text(primaryButtonTitle)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(foregroundColor)
                            .frame(height: 55)
                            .background(backgroundColor, in: .rect(cornerRadius: 20))
                    }
//                    .geometryGroup() iOS17 +
//                    .drawingGroup()?
//                    .compositingGroup() ?
                    
                    if permissionStatus == .notDetermined
                    {
                        Button
                        {
                            onSecondaryButtonTap()
                        }
                        label:
                        {
                            Text(config.secondaryButtonTitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(foregroundColor)
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            }
            .blurOpacity(!askPermission)
        }
        .onDisappear { loopContinues = false }
        .onChange(of: permissionStatus)
        { newValue in
            if newValue != .notDetermined
            {
                withAnimation(.smooth(duration: 0.3, extraBounce: 0))
                {
                    askPermission = false
                    showArrow = false
                }
            }
        }
    }
    
    @ViewBuilder
    private func iPhonePreview() -> some View
    {
        GeometryReader
        {
            let size = $0.size
            let scale = min(size.height / 340, 1)
            let width: CGFloat = 320
            let cornerRadius: CGFloat = 30
            
            ZStack(alignment: .top)
            {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor.opacity(0.06))
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.gray.opacity(0.5), lineWidth: 1.5)
                
                VStack(spacing: 15)
                {
                    HStack(spacing: 15)
                    {
                        RoundedRectangle(cornerRadius: 20)
                        
                        RoundedRectangle(cornerRadius: 20)
                    }
                    .frame(height: 130)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 4), spacing: 15)
                    {
                        ForEach(1...12, id: \.self)
                        { _ in
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 55)
                        }
                    }
                }
                .padding(20)
                .padding(.top, 20)
                .foregroundStyle(backgroundColor.opacity(0.1))
                
                HStack(spacing: 4)
                {
                    Text("9:41")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image(systemName: "cellularbars")
                    
                    Image(systemName: "wifi")
                    
                    Image(systemName: "battery.50percent")
                }
                .font(.caption2)
                .padding(.horizontal, 20)
                .padding(.top, 15)
                
                NotificationView()
            }
            .frame(width: width)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .mask {
                LinearGradient(
                    stops: [.init(color: .white, location: 0), .init(color: .clear, location: 0.9)],
                    startPoint: .top,
                    endPoint: .bottom)
                .padding(-1)
            }
            .scaleEffect(scale, anchor: .top)
        }
    }
    
    @ViewBuilder
    private func NotificationView() -> some View
    {
        HStack(alignment: .center, spacing: 8)
        {
            notificationLogo
            
            VStack(alignment: .leading, spacing: 4)
            {
                HStack
                {
                    Text(config.notificationTitle)
                        .font(.callout)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Text("Agora")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                }
                
                Text(config.notificationContent)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(.background)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: .gray.opacity(0.5), radius: 1.5)
        .padding(.horizontal, 12)
        .padding(.top, 40)
        .offset(y: animateNotification ? 0 : -200)
        .clipped()
        .task {
            await loopAnimation()
        }
    }
    
    private func loopAnimation() async
    {
        guard !reduceMotion else { return }
        try? await Task.sleep(for: .seconds(0.5))
        
        withAnimation(.smooth(duration: 1))
        {
            animateNotification = true
        }
        
        try? await Task.sleep(for: .seconds(4))
        
        withAnimation(.smooth(duration: 1))
        {
            animateNotification = false
        }
        
        guard loopContinues else { return }
        try? await Task.sleep(for: .seconds(1.3))
        await loopAnimation()
    }
    
    private func handlePrimaryButtonTap()
    {
        if permissionStatus == .notDetermined
        {
            withAnimation(.smooth(duration: 0.3, extraBounce: 0))
            {
                askPermission = true
            }
            
            Task
            {
                try? await Task.sleep(for: .seconds(0.3))
                
                withAnimation(.smooth(duration: 0.3, extraBounce: 0))
                {
                    showArrow = true
                }
            }
        }
        
        onPrimaryButtonTap()
    }
    
    private var primaryButtonTitle: String
    {
        switch permissionStatus
        {
            case .authorized:
                return "Tudo pronto"
            case .denied:
                return "Ir para Ajustes"
            case .notDetermined:
                return config.primaryButtonTitle
        }
    }
    
    var backgroundColor: Color
    {
        colorScheme == .dark ? .white : .black
    }
    
    var foregroundColor: Color
    {
        colorScheme != .dark ? .white : .black
    }
}

struct ContentViewForNotificationOnboardingTest: View
{
    var body: some View
    {
        let config = NotificationOnboardingConfig(
            title: "Receba alertas dos\nseus jogos salvos",
            content: "Ative as notificações para lembrar dos jogos que você marcou no app.",
            notificationTitle: "Jogo começando agora",
            notificationContent: "Flamengo x Palmeiras • Premiere",
            primaryButtonTitle: "Ativar notificações",
            secondaryButtonTitle: "Agora não"
        )
        
        NotificationOnboarding(config: config, permissionStatus: .notDetermined)
        {
            Image(systemName: "applelogo")
                .font(.title2)
                .foregroundStyle(.background)
                .frame(width: 40, height: 40)
                .background(.primary)
                .clipShape(.rect(cornerRadius: 12))
            
        } onPrimaryButtonTap: {
            print("Primary Button Tapped!")
        } onSecondaryButtonTap: {
            print("Secondary Button Tapped!")
        }
    }
}

fileprivate extension View
{
    @ViewBuilder
    func blurOpacity(_ status: Bool) -> some View
    {
        self
            .compositingGroup()
            .opacity(status ? 1 : 0)
            .blur(radius: status ? 0 : 10)
    }
    
    var isiOS26: Bool
    {
        if #available(iOS 26, *)
        {
            return true
        }
        
        return false
    }
}

#Preview
{
//    NotificationOnboarding()
    ContentViewForNotificationOnboardingTest()
}
