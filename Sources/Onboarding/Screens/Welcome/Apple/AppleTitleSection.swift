//
//  AppleTitleSection.swift
//
//
//  Created by James Sedlacek on 12/30/23.
//

import SwiftUI

@MainActor
struct AppleTitleSection {
    private let config: AppleWelcomeScreen.Configuration
    private let shouldShowAppIcon: Bool
    @State private var isAnimating = false

    init(
        config: AppleWelcomeScreen.Configuration,
        shouldShowAppIcon: Bool
    ) {
        self.config = config
        self.shouldShowAppIcon = shouldShowAppIcon
    }

    private func onAppear() {
        Animation.titleSection.deferred {
            isAnimating = true
        }
    }
}

@MainActor
extension AppleTitleSection: View {
    var body: some View {
        VStack(alignment: config.titleSectionAlignment, spacing: 1) {
            appIconView
            welcomeToText
            appDisplayNameText
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: config.titleSectionAlignment.toAlignment
        )
        .padding(.horizontal, 38)
        .font(.title)
        .opacity(isAnimating ? 1 : 0)
        .scaleEffect(isAnimating ? 1.0 : 0.5)
        .onAppear(perform: onAppear)
    }

    @ViewBuilder
    private var appIconView: some View {
        if shouldShowAppIcon {
            config.appIcon
                .resizable()
                .frame(width: 80, height: 80)
                .containerShape(.rect(cornerRadius: 10))
                .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                .padding(.bottom)
        }
    }

    private var welcomeToText: some View {
        Text(.onboardingWelcomeTo, bundle: .module)
            .foregroundStyle(.primary)
            .fontWeight(.bold)
    }

    private var appDisplayNameText: some View {
        Text(config.appDisplayName)
            .font(config.appDisplayNameFont)
            .fontWeight(config.appDisplayNameWeight)
            .fontWidth(config.appDisplayNameWidth)
            .foregroundStyle(config.accentColor)
    }
}

#Preview("Default") {
    AppleTitleSection(
        config: .mock,
        shouldShowAppIcon: true
    )
}

#Preview("Custom Font") {
    AppleTitleSection(
        config: .init(
            appDisplayName: "Custom Font",
            appDisplayNameFont: .largeTitle,
            appDisplayNameWeight: .ultraLight,
            appDisplayNameWidth: .compressed,
            appIcon: Image(.mockAppIconResource),
            features: [.mock],
            continueAction: {}
        ),
        shouldShowAppIcon: true
    )
}
