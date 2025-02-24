//
//  WaterChallengeView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI
import ConfettiSwiftUI

struct WaterChallengeView: View {
    
    let cornerRadius: CGFloat = 8.0
    
    var date: Date
    var dateStatus: DateStatus
    
    @State private var triggerConfetti: Int = 0
    @State private var isSliderVisible: Bool = false
    @State private var challenge: WaterChallengeEntry
    @State private var waterChallengeGoal: CGFloat
    @State private var lastChangedGoal: CGFloat
    @State private var isSavingOperation: Bool = false
    @State private var waterGoalAchievementText: String = ""
    @State private var waterGoalSuggestionText: String = ""
    @State private var waterHydrationText: String = ""
    
    @State private var reachedGoalCount: Int = 0
    @State private var hydrationTextPromptCount: Int = 0
    
    private let mealPlanner = MealPlanManager.shared
    private let hydrationMessages = HydrationMessageManager.shared
    
    init(challenge: WaterChallengeEntry, date: Date, dateStatus: DateStatus) {
        self.date = date
        self.dateStatus = dateStatus
        self.lastChangedGoal = challenge.goal
        self.waterChallengeGoal = challenge.goal
        _challenge = State(initialValue: challenge)
    }
    
    var body: some View {
        VStack(spacing: 2) {
            // Title
            Text("Water Challenge")
                .font(.system(size: 18).bold())
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                .padding(.horizontal, 5)
            
            if isSliderVisible && dateStatus == .today {
                
                VStack (spacing: 15) {
                    let (animate, message) = validateGoalSuggestionMessage()
                    TypingEffectView(
                        fullText: message,
                        shouldAnimate: animate
                    )
                    
                    HStack {
                        Text("2L")
                            .font(.system(size: 16).bold())
                            .foregroundStyle(.black.opacity(0.6))
                        
                        Slider(value: $waterChallengeGoal, in: 2.0...5.0, step: 0.2)
                            .tint(.blue.opacity(0.7))
                            .scaleEffect(0.95)
                            .onChange(of: waterChallengeGoal) { _, newValue in
                                challenge.goal = waterChallengeGoal
                            }
                        
                        Text("5L")
                            .font(.system(size: 16).bold())
                            .foregroundStyle(.black.opacity(0.6))
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)
            }
            
            ZStack {
                // Center Water Progress View
                WaterProgressView(
                    goal: challenge.goal,
                    progress: challenge.alphaProgress(),
                    dateStatus: dateStatus,
                    onIncrease: { increaseProgress() },
                    onDecrease: { decreaseProgress() }
                )
                .confettiCannon(
                    trigger: $triggerConfetti,
                    repetitions: 3,
                    repetitionInterval: 0.7
                )
                .onTapGesture(perform: {
                    if User.shared.subscription == .free {
                        PaywallVisibilityManager.show(triggeredBy: .attemptWaterChallengeUsage)
                    }
                })
                
                if dateStatus == .today {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSliderVisible.toggle()
                        }
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 20).bold())
                            .foregroundColor(.blue.opacity(0.7))
                            .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 20)
                    .padding(.trailing, 10)
                }
            }
            
            // Goal Display
            VStack(spacing: 5) {
                Text("%\(String(format: "%.0f", challenge.alphaProgress() * 100)) completed")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .animation(.easeInOut(duration: 0.5), value: challenge.alphaProgress())
                
                Text("\(formatGoal(challenge.goal))L Daily Goal")
                    .font(.system(size: 20).bold())
                    .foregroundStyle(.black.opacity(0.6))
                
                if !isSliderVisible && dateStatus != .future {
                    
                    if challenge.alphaProgress() >= 0.99 {
                        TypingEffectView(
                            fullText: waterGoalAchievementText,
                            shouldAnimate: reachedGoalCount == 0 && dateStatus == .today
                        )
                        .padding(.top, 15)
                        .onAppear {
                            validateHydrationMessage()
                        }
                    }
                    
                    else {
                        TypingEffectView(
                            fullText: waterHydrationText,
                            shouldAnimate: hydrationTextPromptCount < 1 && dateStatus == .today
                        )
                        .padding(.top, 15)
                        .onAppear {
                            validateHydrationMessage()
                        }
                    }
                }
            }
        }
        .onChange(of: waterChallengeGoal) {
            oldValue,
            newValue in
            
            if challenge.progress > challenge.goal {
                challenge.progress = challenge.goal
            }
            
            if !isSavingOperation && lastChangedGoal != newValue{
                isSavingOperation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    mealPlanner.updateWaterChallengeGoal(
                        for: date,
                        with: waterChallengeGoal
                    )
                    isSavingOperation = false
                    lastChangedGoal = newValue
                }
            }
        }
        .onAppear {
            validateWaterProgress(for: false)
        }
    }
    
    private func handleCompletion() {
        triggerConfetti += 1
    }
    
    private func increaseProgress() {
        if User.shared.subscription == .pro {
            let newProgress = min(challenge.progress + 0.2, challenge.goal)
            updateChallengeProgress(newProgress)
        }
        else {
            PaywallVisibilityManager.show(triggeredBy: .attemptWaterChallengeUsage)
        }
    }
    
    private func decreaseProgress() {
        if User.shared.subscription == .pro {
            let newProgress = max(challenge.progress - 0.2, 0)
            updateChallengeProgress(newProgress)
        }
        else {
            PaywallVisibilityManager.show(triggeredBy: .attemptWaterChallengeUsage)
        }
    }
    
    private func validateGoalSuggestionMessage() -> (Bool, String) {
        if waterGoalSuggestionText.isEmpty {
            let message = HydrationMessageManager.shared.getNextGoalSuggestionMessages()
            DispatchQueue.main.async {
                self.waterGoalSuggestionText = message // ✅ Defer state update to avoid SwiftUI conflicts
            }
            return (true, message) // ✅ Correct tuple return
        } else {
            return (false, waterGoalSuggestionText) // ✅ Tuple format
        }
    }
    
    private func validateHydrationMessage() {
        if waterHydrationText.isEmpty {
            DispatchQueue.main.async {
                let message = dateStatus == .today ? hydrationMessages.getNextHydrationMessage() : hydrationMessages.getConclusitionText(for: challenge.progress)
                self.waterHydrationText = message
            }
        } else {
            DispatchQueue.main.async {
                self.hydrationTextPromptCount += 1
            }
        }
    }
    
    private func updateChallengeProgress(_ newProgress: CGFloat) {
        challenge.progress = newProgress
        
        mealPlanner.updateWaterChallengeProgress(
            for: date,
            with: newProgress,
            in: challenge.goal
        )
        
        validateWaterProgress()
    }
    
    private func validateWaterProgress(for confetti: Bool = true) {
        if challenge.alphaProgress() >= 0.99 {
                        
            if reachedGoalCount == 0 {
                waterGoalAchievementText = hydrationMessages.getNextWaterGoalAchievementMessages()
            }
            
            else if confetti {
                handleCompletion()
            }
            
            DispatchQueue.main.async {
                self.reachedGoalCount += 1
            }
        }
    }
    
    /// Formats the goal to remove unnecessary decimals (e.g., "2.0" -> "2", "2.2" -> "2.2")
    private func formatGoal(_ goal: CGFloat) -> String {
        return goal.truncatingRemainder(dividingBy: 1) == 0 ?
        String(format: "%.0f", goal) : // No decimal if whole number
        String(format: "%.1f", goal)   // One decimal place if fractional
    }
}

struct TypingEffectView: View {
    
    var fullText: String
    var shouldAnimate: Bool = true
    var displayAICoach: Bool = true
    
    var fontColor: Color = .black.opacity(0.6)
    var fontWeight: Font.Weight = .regular
    var fontSize: CGFloat = 15
    
    private let words: [String]
    
    @State private var displayedText: AttributedString = ""
    @State private var isVisible: Bool = false
    @State private var currentWordIndex = 0
    
    init(
        fullText: String,
        shouldAnimate: Bool = true,
        fontSize: CGFloat = 15,
        fontColor: Color = .black.opacity(0.6),
        fontWeight: Font.Weight = .regular,
        aiCoachVisibility: Bool = true
    ) {
        self.fullText = fullText
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.fontWeight = fontWeight
        self.shouldAnimate = shouldAnimate
        self.displayAICoach = aiCoachVisibility
        self.words = fullText.components(separatedBy: " ")
    }
    
    var body: some View {
        Text(styledAttributedText())
            .padding(.horizontal)
            .multilineTextAlignment(.leading)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            checkVisibility(geo)
                        }
                        .onChange(of: geo.frame(in: .global).minY) { _, _ in
                            checkVisibility(geo)
                        }
                    
                }
            )
        
    }
    
    private func checkVisibility(_ geo: GeometryProxy) {
        let screenHeight = UIScreen.main.bounds.height
        let minY = geo.frame(in: .global).minY
        
        if minY > 0 && minY < screenHeight && !isVisible {
            isVisible = true
            startTypingEffect()
        }
    }
    
    private func startTypingEffect() {
        
        displayedText = ""
        currentWordIndex = 0
        
        if shouldAnimate {
            typeNextWord()
        }
        
        else {
            displayedText = AttributedString(fullText)
        }
    }
    
    private func typeNextWord() {
        guard currentWordIndex < words.count else { return }
        let delay = Double.random(in: 0.15...0.3)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: delay)) {
                
                let newWord = words[currentWordIndex]
                var attributedWord = AttributedString("\(newWord) ")
                attributedWord.foregroundColor = fontColor
                attributedWord.font = .system(size: fontSize, weight: fontWeight)
                displayedText += attributedWord
            }
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            currentWordIndex += 1
            typeNextWord()
        }
    }
    
    private func styledAttributedText() -> AttributedString {
        var aiText = AttributedString("AI Coach: ")
        aiText.foregroundColor = .purple
        aiText.font = .system(size: 16).bold()
        
        if displayAICoach {
            return aiText + displayedText
        }
        
        else {
            return displayedText
        }
    }
}

// **Preview**
struct TypingEffectView_Previews: PreviewProvider {
    static var previews: some View {
        TypingEffectView(fullText: "Hydration boosts energy, focus, and digestion! A healthy goal is 2L to 5L—choose wisely!")
    }
}
