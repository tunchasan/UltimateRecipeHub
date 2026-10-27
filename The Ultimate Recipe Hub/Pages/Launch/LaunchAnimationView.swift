//
//  LaunchAnimationView.swift
//  The Ultimate Recipe Hub
//
//  App-open animation (about 1.35 s of drawn frames): the app icon builds itself. The white ring draws, and when it
//  closes the logo gets a small press, like a tap on the icon, and sends out one ripple while the apple pops in.
//  Then the screen opens in a growing circle onto the app underneath.
//  MainView shows it once per cold launch. With Reduce Motion on, it's a short plain fade instead.
//

import SwiftUI
import UIKit

struct LaunchAnimationView: View {
    /// Called once when the animation is over and the view can be removed.
    var onFinished: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var clock = LaunchClock()
    @State private var fadeOut = false
    @State private var finished = false

    static let duration: Double = revealEnd / 1000   // seconds
    /// The closing transition: a circle opens from the logo's centre onto the app (milliseconds).
    private static let revealStart: Double = 1000   // ~0.3 s after the apple settles
    private static let revealEnd: Double = 1350
    static let logoSize: CGFloat = 180          // points
    /// Vibrant green: Display P3 55/C2/5A. The launch screen asset (LaunchScreenBackground) holds the same
    /// numbers but marked sRGB, on purpose: iOS draws launch screens by taking the colour's sRGB numbers and
    /// showing them as Display P3 (measured on an iPhone screen recording). So sRGB 55/C2/5A there shows as
    /// P3 55/C2/5A here. If you change the green, put the same three numbers in both places.
    static let background = Color(.displayP3, red: 0x55 / 255, green: 0xC2 / 255, blue: 0x5A / 255)

    var body: some View {
        Group {
            if reduceMotion {
                // Plain fade: the finished logo, then fade away.
                scene(at: 1200, ripples: false)
                    .opacity(fadeOut ? 0 : 1)
                    .task {
                        try? await Task.sleep(for: .seconds(0.6))
                        withAnimation(.easeOut(duration: 0.35)) { fadeOut = true }
                        try? await Task.sleep(for: .seconds(0.4))
                        finish()
                    }
            } else {
                scene(at: clock.elapsed)
                    .onAppear { clock.start() }
                    .onDisappear { clock.stop() }
                    .onChange(of: clock.elapsed >= Self.duration * 1000) { _, done in
                        if done { finish() }
                    }
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
        // Sent to the background mid-animation (a call, a swipe home): skip the rest instead of
        // resuming it when the user comes back.
        .onChange(of: scenePhase) { _, phase in
            if phase == .background { finish() }
        }
    }

    /// Ends the animation exactly once, whichever way it ends.
    private func finish() {
        guard !finished else { return }
        finished = true
        clock.stop()
        onFinished()
    }

    // MARK: - The scene at time t (milliseconds)

    @ViewBuilder
    private func scene(at t: Double, ripples: Bool = true) -> some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let k = Self.logoSize / 1024             // icon artwork is drawn in a 1024 x 1024 space
            let revealRadius = Self.ease(Self.progress(t, Self.revealStart, Self.revealEnd), Self.easeInOut) * hypot(w, h) * 0.55

            ZStack {
                Self.background

                // One ripple leaves the outer ring when the white ring closes, like a tap (a thin line that doesn't scale).
                if ripples {
                    let r = Self.ripple(t)
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 788 * k * r.scale, height: 788 * k * r.scale)
                        .opacity(r.opacity)
                }

                ZStack {
                    // Faint outer ring: grows in and pulses as the ripple leaves; the reveal simply opens over it.
                    Circle()
                        .stroke(Color.white.opacity(0.35), lineWidth: 60 * k)
                        .frame(width: 788 * k, height: 788 * k)
                        .scaleEffect(Self.outerScale(t))
                        .opacity(Self.outerOpacity(t))

                    // White ring draws itself from the top.
                    Circle()
                        .trim(from: 0, to: Self.progress(t, 60, 560))
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 62 * k, lineCap: .butt))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 614 * k, height: 614 * k)

                    // Apple pops in with the ripple.
                    AppleShape()
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 34 * k, lineCap: .round, lineJoin: .round))
                        .frame(width: Self.logoSize, height: Self.logoSize)
                        .scaleEffect(Self.appleScale(t), anchor: UnitPoint(x: 0.5, y: 510.0 / 1024))
                        .opacity(Self.progress(t, 513, 600))
                }
                .frame(width: Self.logoSize, height: Self.logoSize)
                .scaleEffect(Self.tapScale(t))   // the tap: a quick press as the ring closes
            }
            .frame(width: w, height: h)
            // Opens from the logo's centre onto the app underneath.
            .mask {
                Rectangle()
                    .overlay {
                        Circle()
                            .frame(width: revealRadius * 2, height: revealRadius * 2)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
            }
        }
    }

    // MARK: - Timing (milliseconds, from the Recipe Hub App Mockups storyboard)

    private static let rippleStart: Double = 560   // the moment the white ring closes

    private static func outerScale(_ t: Double) -> Double {
        if t < 60 { return lerp(0.85, 1, ease(progress(t, 0, 60), easeOut)) }
        let s = rippleStart
        if t >= s && t < s + 111 {                                  // small pulse as the ripple leaves
            return t < s + 35
                ? lerp(1, 1.05, ease(progress(t, s, s + 35), easeOut))
                : lerp(1.05, 1, ease(progress(t, s + 35, s + 111), easeOut))
        }
        return 1
    }

    private static func outerOpacity(_ t: Double) -> Double {
        t < 60 ? progress(t, 0, 60) : 1
    }

    private static func appleScale(_ t: Double) -> Double {
        if t < 513 { return 0.3 }
        if t < 600 { return lerp(0.3, 1.1, ease(progress(t, 513, 600), easeOut)) }
        if t < 684 { return lerp(1.1, 1, ease(progress(t, 600, 684), easeOut)) }
        return 1
    }

    /// The logo presses in just before the ring closes and springs back as the ripple leaves.
    private static func tapScale(_ t: Double) -> Double {
        let s = rippleStart
        if t < s - 80 || t >= s + 160 { return 1 }
        if t < s { return lerp(1, 0.94, ease(progress(t, s - 80, s), easeOut)) }
        return lerp(0.94, 1, ease(progress(t, s, s + 160), easeOut))
    }

    private static func ripple(_ t: Double) -> (scale: Double, opacity: Double) {
        let s = rippleStart
        if t < s { return (1, 0) }
        if t < s + 40 { return (1, 0.7 * progress(t, s, s + 40)) }
        let p = ease(progress(t, s + 40, s + 1200), easeOut)
        return (lerp(1, 3.6, p), 0.7 * (1 - p))
    }

    // MARK: - Helpers

    private static func progress(_ t: Double, _ a: Double, _ b: Double) -> Double { min(1, max(0, (t - a) / (b - a))) }
    private static func lerp(_ a: Double, _ b: Double, _ p: Double) -> Double { a + (b - a) * p }
    private static func ease(_ p: Double, _ curve: (Double) -> Double) -> Double { curve(p) }
    private static func easeOut(_ x: Double) -> Double { 1 - pow(1 - x, 3) }
    private static func easeInOut(_ x: Double) -> Double { x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2 }
}

/// Animation time that only advances on frames that are actually drawn. If the app is busy at launch (loading
/// recipes on the main thread), the animation pauses on the current frame and continues smoothly afterwards,
/// instead of skipping ahead. Each frame adds at most 1/30 s.
@MainActor
private final class LaunchClock: NSObject, ObservableObject {
    @Published private(set) var elapsed: Double = 0   // milliseconds
    private var link: CADisplayLink?
    private var lastTimestamp: CFTimeInterval?

    func start() {
        guard link == nil else { return }
        let link = CADisplayLink(target: self, selector: #selector(tick(_:)))
        link.add(to: .main, forMode: .common)
        self.link = link
    }

    func stop() {
        link?.invalidate()
        link = nil
    }

    @objc private func tick(_ link: CADisplayLink) {
        if let lastTimestamp {
            elapsed += min(link.timestamp - lastTimestamp, 1.0 / 30) * 1000
        }
        lastTimestamp = link.timestamp
    }
}

/// The apple from the app icon (stem and body), drawn in the icon's 1024 x 1024 space and scaled to the frame.
private struct AppleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let k = min(rect.width, rect.height) / 1024
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: rect.minX + x * k, y: rect.minY + y * k) }
        var path = Path()
        // Stem
        path.move(to: p(474, 340))
        path.addCurve(to: p(512, 440), control1: p(496, 352), control2: p(510, 384))
        // Body
        path.move(to: p(512, 440))
        path.addCurve(to: p(402, 400), control1: p(472, 416), control2: p(436, 398))
        path.addCurve(to: p(334, 502), control1: p(354, 403), control2: p(328, 444))
        path.addCurve(to: p(434, 680), control1: p(344, 590), control2: p(392, 670))
        path.addCurve(to: p(512, 668), control1: p(468, 688), control2: p(488, 668))
        path.addCurve(to: p(590, 680), control1: p(536, 668), control2: p(556, 688))
        path.addCurve(to: p(690, 502), control1: p(632, 670), control2: p(680, 590))
        path.addCurve(to: p(622, 400), control1: p(696, 444), control2: p(670, 403))
        path.addCurve(to: p(512, 440), control1: p(588, 398), control2: p(552, 416))
        path.closeSubpath()
        return path
    }
}

#Preview {
    LaunchAnimationView {}
}
