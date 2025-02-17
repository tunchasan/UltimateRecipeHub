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
    var dateStatus: DateStatus
    var onIncrease: () -> Void
    var onDecrease: () -> Void
    
    @State private var phase: CGFloat = 0.0
    @State private var isVisible: Bool = false // **Tracks visibility**
    @State private var lastUpdateTime: Date = Date()
    
    var body: some View {
        HStack(spacing: 20) {
            
            if dateStatus == .today {
                Button(action: { onDecrease() }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue.opacity(0.7))
                }
                .opacity(progress == 0 ? 0.25 : 1)
                .disabled(progress == 0)
                .animation(.easeInOut(duration: 0.2), value: progress)
            }
            
            ZStack {
                GeometryReader { geometry in
                    Color.clear
                        .onAppear { checkVisibility(geometry: geometry) }
                        .onChange(of: geometry.frame(in: .global)) { _, _ in
                            checkVisibility(geometry: geometry)
                        }
                }
                
                // Outer Circle
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 8)
                    .frame(width: 140, height: 140)
                
                // Progress Circle
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        Color.blue.opacity(0.5),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(90))
                    .frame(width: 140, height: 140)
                    .animation(.easeInOut(duration: 0.3), value: progress)
                
                if dateStatus == .today && isVisible {
                    TimelineView(.animation) { timeline in
                        WaterWave(progress: progress * 0.95, waveHeight: 8, phase: phase)
                            .fill(Color.blue.opacity(0.9))
                            .clipShape(Circle())
                            .frame(width: 135, height: 135)
                            .onChange(of: timeline.date) { _, _ in
                                accelerateWaveAnimation()
                            }
                    }
                } else {
                    WaterWave(progress: progress * 0.95, waveHeight: 8, phase: phase)
                        .fill(Color.blue.opacity(0.9))
                        .clipShape(Circle())
                        .frame(width: 135, height: 135)
                }
                
                // Water Level Text
                Text(formatWaterLevel(progress: progress, goal: goal))
                    .font(.title2.bold())
                    .foregroundColor(.black.opacity(0.6))
                    .animation(.easeInOut(duration: 0.2), value: progress)
            }
            .frame(width: 150, height: 150)
            
            if dateStatus == .today {
                Button(action: { onIncrease() }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue.opacity(0.7))
                }
                .opacity(progress == 1 ? 0.25 : 1)
                .disabled(progress == 1)
                .animation(.easeInOut(duration: 0.2), value: progress)
            }
        }
        .padding()
        .onDisappear {
            isVisible = false
        }
    }
    
    // **Checks if the view is visible on screen**
    private func checkVisibility(geometry: GeometryProxy) {
        let frame = geometry.frame(in: .global)
        let screenHeight = UIScreen.main.bounds.height
        isVisible = frame.minY < screenHeight && frame.maxY > 0
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
    
    // **Increases wave animation speed when visible**
    private func accelerateWaveAnimation() {
        if isVisible {
            let now = Date()
            let timeInterval = now.timeIntervalSince(lastUpdateTime)
            
            if timeInterval > 0.025 { // **Updates wave phase every 0.05 seconds (2x faster)**
                DispatchQueue.main.async {
                    phase += 0.1 // **Increases wave speed**
                    lastUpdateTime = now
                    print(phase)
                }
            }
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
