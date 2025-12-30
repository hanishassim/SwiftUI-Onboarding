//
//  ProgressiveBlurView.swift
//
//  Created by Hanis on 12/30/23.
//

import SwiftUI

/// A view that creates a "Variable Blur" effect using layered materials and gradient masks.
public struct ProgressiveBlurView: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            // Ensure the background is true white as it becomes more opaque
            // This prevents the grayish tone often seen with materials on light backgrounds
            Rectangle()
                .fill(.white)
                .mask(
                    LinearGradient(
                        colors: [.black.opacity(0), .black, .black, .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Layered materials with gradients to simulate variable blur
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask(
                    LinearGradient(
                        colors: [.black.opacity(0), .black, .black, .black, .black, .black, .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Rectangle()
                .fill(.regularMaterial)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0.2),
                            .init(color: .black, location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Rectangle()
                .fill(.thickMaterial)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<20) { i in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.gradient)
                        .frame(height: 100)
                        .overlay(Text("Item \(i)").foregroundStyle(.white))
                }
            }
            .padding()
        }
        
        VStack {
            Spacer()
            ProgressiveBlurView()
                .frame(height: 200)
        }
    }
}
