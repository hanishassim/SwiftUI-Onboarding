//
//  AppleFeatureSection.swift
//  
//
//  Created by James Sedlacek on 12/30/23.
//

import SwiftUI

@MainActor
struct AppleFeatureSection: View {
    private let config: AppleWelcomeScreen.Configuration
    @State private var isAnimating: [Bool] = []

    init(config: AppleWelcomeScreen.Configuration) {
        self.config = config
        _isAnimating = .init(
            initialValue: Array(
                repeating: false,
                count: config.features.count
            )
        )
    }

    var body: some View {
        ForEach(
            config.features.indices,
            id: \.self,
            content: featureView
        )
    }

    private func featureView(for index: Int) -> some View {
        FeatureView(
            info: config.features[index],
            accentColor: config.accentColor
        )
        .opacity(isAnimating[index] ? 1 : 0)
        .offset(y: isAnimating[index] ? 0 : 100)
        .onAppear {
            Animation.feature(index: index).deferred {
                isAnimating[index] = true
            }
        }
    }
}

struct FeatureView: View {
    private let info: FeatureInfo
    private let accentColor: Color

    init(info: FeatureInfo, accentColor: Color) {
        self.info = info
        self.accentColor = accentColor
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
//            ZStack {
//                Circle()
//                    .fill(Color.randomNonWhite)
//                    .frame(width: 40, height: 40)
                
                iconImage
//            }

            VStack(alignment: .leading, spacing: 2) {
                titleText
                contentText
            }

            Spacer()
        }
    }

    private var iconImage: some View {
        info.image
            .font(.title)
            .foregroundStyle(accentColor)
//            .foregroundStyle(
//                Color.randomNonWhite
//                    .shadow(.inner(radius: 0.3))
//            )
            .frame(width: 38)
    }

    private var titleText: some View {
        Text(info.title)
            .foregroundStyle(.primary)
            .font(.headline.weight(.semibold))
    }

    private var contentText: some View {
        Text(info.content)
            .foregroundStyle(.secondary)
            .font(.body)
    }
}

extension Color {
    static var randomNonWhite: Color {
        let minBrightness: Double = 0.2 // Adjust this value to control how light the colors can be (0.0 to 1.0)
        
        var red: Double
        var green: Double
        var blue: Double
        
        // Loop until a non-white color is generated
        repeat {
            red = Double.random(in: 0...1)
            green = Double.random(in: 0...1)
            blue = Double.random(in: 0...1)
        } while red > minBrightness && green > minBrightness && blue > minBrightness && (abs(red - green) < 0.1 && abs(green - blue) < 0.1) // Basic check for gray-ish colors near white
        
        return Color(red: red, green: green, blue: blue)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            AppleFeatureSection(config: .mock)
        }
        .padding(40)
    }
    .defaultScrollAnchor(.center, for: .alignment)
    .scrollBounceBehavior(.basedOnSize)
}
