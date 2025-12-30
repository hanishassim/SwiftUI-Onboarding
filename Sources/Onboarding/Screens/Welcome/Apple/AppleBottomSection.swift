//
//  AppleBottomSection.swift
//  
//
//  Created by James Sedlacek on 12/30/23.
//

import SwiftUI

@MainActor
struct AppleBottomSection {
    private let accentColor: Color
    private let buttonTextTintColor: Color
    private let appDisplayName: String
    private let privacyPolicyURL: URL?
    private let continueAction: () -> Void
    @State private var isAnimating: Bool = false
    @Environment(\.openURL) private var openURL

    init(
        accentColor: Color,
        buttonTextTintColor: Color = .white,
        appDisplayName: String,
        privacyPolicyURL: URL?,
        continueAction: @escaping () -> Void
    ) {
        self.accentColor = accentColor
        self.buttonTextTintColor = buttonTextTintColor
        self.appDisplayName = appDisplayName
        self.privacyPolicyURL = privacyPolicyURL
        self.continueAction = continueAction
    }

    private func onAppear() {
        Animation.bottomSection.deferred {
            isAnimating = true
        }
    }

    private func disclosureAction() {
        guard let privacyPolicyURL else { return }
        openURL(privacyPolicyURL)
    }
}

@MainActor
extension AppleBottomSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            dataPrivacyImage
            disclosureText
            continueButton
        }
        .padding(.horizontal, 38)
        .padding(.top, 24)
        .background {
            ProgressiveBlurView()
        }
        .opacity(isAnimating ? 1 : 0)
        .onAppear(perform: onAppear)
    }

    private var dataPrivacyImage: some View {
        Image(.dataPrivacyResource)
            .resizable()
            .foregroundStyle(accentColor)
            .aspectRatio(contentMode: .fit)
            .frame(height: 37)
    }

    private var disclosureText: some View {
        Group {
            Text(verbatim: appDisplayName)
                .foregroundStyle(.secondary) +
            Text(.privacyDataCollection, bundle: .module)
                .foregroundStyle(.secondary) +
            Text(.privacyDataManagement, bundle: .module)
                .foregroundStyle(accentColor)
                .bold()
        }
        .multilineTextAlignment(.leading)
        .font(.caption2)
        .padding(.bottom, 22)
        .padding(.top, 8)
        .onTapGesture(perform: disclosureAction)
    }

    private var continueButton: some View {
        let button = Button(
            action: continueAction,
            label: continueText
        )
            .tint(accentColor)
            .font(.body.weight(.medium))
            .controlSize(.large)
        
        if #available(iOS 26.0, *) {
            return button
                .buttonStyle(.glassProminent)
        }
        
        return button
            .buttonStyle(.borderedProminent)
    }

    private func continueText() -> some View {
        Text(.actionContinue, bundle: .module)
            .foregroundStyle(buttonTextTintColor)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack {
        Spacer()
    }
    .safeAreaInset(edge: .bottom) {
        AppleBottomSection(
            accentColor: .blue,
            appDisplayName: .init("Test App"),
            privacyPolicyURL: URL(string: "https://example.com/privacy"),
            continueAction: {
                print("Continue Tapped")
            }
        )
    }
}
