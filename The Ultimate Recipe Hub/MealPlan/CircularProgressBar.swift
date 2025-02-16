//
//  CircularProgressBar.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.02.2025.
//

import SwiftUI

struct WaterProgressView: View {
    var onComplete: () -> Void
    @Binding public var progress: CGFloat
    @State private var phase: CGFloat = 0.0 // Wave movement phase
    
    var body: some View {
        HStack(spacing: 30) {
            // Minus Button (Decrease Water Level)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) { // **Smooth animation**
                    if progress > 0.1 {
                        progress -= 0.1
                    }
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue.opacity(0.7))
            }
            
            ZStack {
                // Outer Circle (Gray Stroke)
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 8)
                    .frame(width: 150, height: 150)
                
                // Circular Progress Background (Solid Blue)
                Circle()
                    .trim(from: 0.0, to: progress) // **Fills from bottom to top**
                    .stroke(
                        Color.blue.opacity(0.25), // **Solid blue progress**
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(90)) // **Flip progress to fill bottom-up**
                    .frame(width: 150, height: 150)
                    .animation(.easeInOut(duration: 0.5), value: progress) // **Smooth animation**
                
                // Water Wave (Animated)
                TimelineView(.animation) { timeline in
                    WaterWave(progress: progress * 0.95, waveHeight: 6, phase: phase)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(Circle())
                        .frame(width: 142, height: 142)
                        .onChange(of: timeline.date) { _, _ in
                            phase += 0.05 // **Smooth wave motion**
                        }
                }
                
                // Water Level Text
                Text(formatWaterLevel(progress: progress))
                    .font(.title2.bold())
                    .foregroundColor(.black.opacity(0.5))
            }
            .frame(width: 150, height: 150)
            
            // Plus Button (Increase Water Level)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) { // **Smooth animation**
                    if progress < 0.9 {
                        progress += 0.1
                    }
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue.opacity(0.7))
            }
        }
        .padding()
        .onChange(of: progress) { oldValue, newValue in
            if newValue >= 0.99 {
                onComplete()
            }
        }
    }
    
    // MARK: - Water Level Formatting Function
    func formatWaterLevel(progress: CGFloat) -> String {
        let milliliters = Int(progress * 2000) // Convert progress to ml

        if milliliters >= 1000 {
            let liters = Double(milliliters) / 1000.0
            return String(format: "%.1fL", liters) // Display in Liters with one decimal
        } else {
            return "\(milliliters) ml" // Keep ml for values below 1000
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
