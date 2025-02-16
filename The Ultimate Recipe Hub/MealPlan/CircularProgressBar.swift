//
//  CircularProgressBar.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.02.2025.
//

import SwiftUI

struct WaterProgressView: View {
    var goal: CGFloat
    var progress: CGFloat
    var onIncrease: () -> Void
    var onDecrease: () -> Void

    @State private var phase: CGFloat = 0.0

    var body: some View {
        HStack(spacing: 10) {
            // Decrease Button
            Button(action: { onDecrease() }) {
                Image(systemName: "minus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue.opacity(0.7))
            }

            ZStack {
                // Outer Circle
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 8)
                    .frame(width: 130, height: 130)

                // Progress Circle
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        Color.blue.opacity(0.25),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(90))
                    .frame(width: 130, height: 130)
                    .animation(.easeInOut(duration: 0.5), value: progress)

                // Water Wave
                TimelineView(.animation) { timeline in
                    WaterWave(progress: progress * 0.95, waveHeight: 6, phase: phase)
                        .fill(Color.blue.opacity(0.8))
                        .clipShape(Circle())
                        .frame(width: 125, height: 125)
                        .onChange(of: timeline.date) { _, _ in
                            phase += 0.05
                        }
                }

                // Water Level Text
                Text(formatWaterLevel(progress: progress, goal: goal))
                    .font(.title2.bold())
                    .foregroundColor(.black.opacity(0.5))
            }
            .frame(width: 150, height: 150)

            // Increase Button
            Button(action: { onIncrease() }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue.opacity(0.7))
            }
        }
        .padding()
    }

    // Converts progress into a human-readable string (ml/L)
    private func formatWaterLevel(progress: CGFloat, goal: CGFloat) -> String {
        let milliliters = Int(progress * goal * 1000.0)

        if milliliters >= 1000 {
            let liters = Double(milliliters) / 1000.0
            return String(format: "%.1fL", liters)
        } else {
            return "\(milliliters) ml"
        }
    }
}

// MARK: - Water Wave Effect
struct WaterWave: Shape {
    var progress: CGFloat
    var waveHeight: CGFloat
    var phase: CGFloat
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height * (1.0 - progress) // **Fills based on progress**
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin(relativeX * .pi * 2 + phase) // **Wave animation**
            let y = midHeight + sine * waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}
