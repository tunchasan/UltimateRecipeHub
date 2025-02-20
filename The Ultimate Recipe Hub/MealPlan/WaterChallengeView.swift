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
    
    let hydrationMessages: [String] = [
        "💧 Stay hydrated! Water fuels your energy and focus. 🚀",
        "🥤 Drinking enough water keeps your skin glowing and your mind sharp! Stay refreshed! ✨",
        "🏋️‍♂️ Muscles love water! Hydration helps with performance and recovery. Keep sipping! 💪",
        "🌿 Digestion boost! Water helps break down food and absorb nutrients better. Drink up! 🥗",
        "🚀 Hydration powers your brain! Stay sharp and focused with enough water intake. 💡",
        "❤️ Your heart needs hydration! Proper water intake supports circulation and stamina. 🏃‍♂️",
        "🌟 Hydrate like a pro! Water regulates body temperature and keeps you feeling fresh! ❄️",
        "🍋 Add lemon! A splash of citrus boosts hydration benefits and tastes amazing! 🍊",
        "🛌 Drink water before bed to aid recovery, but not too much to disturb sleep! 🌙",
        "☀️ Hot day? Double up on hydration! Your body loses more water in heat. 🔥",
        "🏃‍♀️ After a workout, water helps prevent cramps and speeds up recovery. Keep sipping! 💦",
        "⚡ Beat fatigue! Dehydration can cause tiredness—grab a glass and feel the difference! 🌊",
        "🧠 Your brain is 75% water! Stay hydrated for better memory and concentration. 📚",
        "🌱 Hydration helps with weight loss! Drinking water before meals can curb hunger. 🍽️",
        "🌊 Sip smart! Carry a water bottle to keep up with your daily hydration goal! 🚰",
        "🥶 Cold water can boost metabolism slightly—great for a refreshing hydration boost! ❄️",
        "☕ Limit caffeine! Too much coffee or tea can dehydrate. Balance with plenty of water. ☕",
        "💆‍♂️ Water helps prevent headaches and migraines! Keep your body well-hydrated. 🌊",
        "🔥 Drinking water can help fight off infections by supporting your immune system. 🛡️",
        "🎯 Listen to your body and drink when thirsty. 💙"
    ]
    
    let goalSuggestionMessages: [String] = [
        "💧 Experts suggest drinking 2L - 5L of water daily to keep your body functioning at its best.",
        "🚰 Staying hydrated with 2L - 5L of water helps regulate body temperature and maintain energy levels.",
        "🧠 Your brain needs water to focus and stay sharp. Aim for 2L - 5L each day to boost mental clarity.",
        "🏃‍♂️ Water supports muscle recovery and joint lubrication. 2L - 5L daily keeps you active and strong.",
        "❤️ Drinking 2L - 5L of water daily helps your heart pump efficiently and maintain circulation.",
        "🔥 Your body loses water through sweat and digestion. Replenish with at least 2L - 5L per day.",
        "🥗 Water aids digestion and prevents bloating. Keeping your intake between 2L - 5L supports gut health.",
        "🌡️ Proper hydration helps regulate your body temperature. Drinking 2L - 5L prevents overheating or chills.",
        "💆‍♂️ Headaches and fatigue? Dehydration might be the cause. Aim for 2L - 5L to feel refreshed.",
        "⚡ Water fuels your metabolism. Drinking 2L - 5L daily can support natural energy and weight balance.",
        "🏋️‍♀️ When you exercise, your body needs more water. The recommended intake of 2L - 5L keeps you hydrated.",
        "🌞 Hot or cold weather affects hydration levels. Keeping between 2L - 5L daily prevents dehydration.",
        "🛌 Drinking enough water throughout the day improves sleep quality and body recovery. 2L - 5L is ideal.",
        "🍋 Water helps detox your body by flushing out toxins. Stick to 2L - 5L daily for optimal health.",
        "🚀 Boost your immune system by staying hydrated. Drinking 2L - 5L supports your body's defenses.",
        "🥶 In winter, people tend to drink less water. Keeping up with 2L - 5L daily helps prevent dehydration.",
        "📉 Dehydration can cause mood swings and dizziness. Keep your intake between 2L - 5L for better well-being.",
        "📊 Studies show that proper hydration improves concentration. Drinking 2L - 5L keeps your brain alert.",
        "🎯 Setting a goal of 2L - 5L per day ensures steady hydration without overloading your system.",
        "🏆 Hydration is the key to a healthy body. Keeping between 2L - 5L a day supports overall wellness."
    ]
    
    let waterGoalAchievementMessages: [String] = [
        "🎉 Amazing! You reached your water goal today! Your body thanks you! 💧",
        "🥳 Hydration champion! You've hit your goal—keep up the great work! 🚰",
        "👏 Cheers to you! Staying hydrated is key to feeling great. Well done! 💙",
        "💦 Mission accomplished! Your body is refreshed and ready for more! 🔥",
        "🌟 Hydration hero! You've kept your body happy and healthy today! 🏆",
        "🌊 You made waves today! Reaching your water goal is a big win! 🏄‍♂️",
        "💧 Every sip counts, and you nailed it today! Keep the momentum going! ⚡",
        "🥤 Hydrated and thriving! Your energy levels are thanking you right now! 🚀",
        "🎯 Goal smashed! Water is life, and you’re winning at it! Keep it flowing! 🔄",
        "🏅 Gold medal for hydration! Your body is running at peak performance! 🏃‍♀️",
        "🥂 Cheers to health! You’ve given your body the hydration it needs today! 🍹",
        "🌿 Your skin, brain, and body are all celebrating—hydration success! 🌟",
        "🎊 Hydration achievement unlocked! Your body is performing at its best! 🔑",
        "🔥 Hydrated and unstoppable! Hitting your water goal keeps you energized! ⚡",
        "💙 Your kidneys, skin, and muscles are high-fiving you right now! Well done! 🙌",
        "🚀 Boost mode activated! Hydration fuels your focus, energy, and mood! 🧠",
        "☀️ You kept your hydration game strong today! Your body feels the difference! 🌊",
        "📈 Hydration levels: MAX! You're setting the standard for self-care! 🏆",
        "💪 Stronger, healthier, and hydrated! You're making smart choices every day! 🏋️",
        "🎶 Hydration rhythm: ON BEAT! Your body is flowing with energy and balance! 🎵"
    ]

    var date: Date
    var dateStatus: DateStatus
    @State private var triggerConfetti: Int = 0
    @State private var isSliderVisible: Bool = false
    @State private var challenge: WaterChallengeEntry
    @State private var waterChallengeGoal: CGFloat
    @State private var lastChangedGoal: CGFloat
    @State private var isSavingOperation: Bool = false
    
    private let mealPlanner = MealPlanManager.shared
    
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
            
            if isSliderVisible && dateStatus == .today{
                VStack (spacing: 15) {
                    let randomMessage = goalSuggestionMessages.randomElement() ??
                    "💧 Experts suggest drinking 2L - 5L of water daily to keep your body functioning at its best."
                    TypingEffectView(
                        fullText: randomMessage
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
                
                if !isSliderVisible && dateStatus == .today {
                    
                    if challenge.alphaProgress() >= 0.99 {
                        let randomCongratsMessage = waterGoalAchievementMessages.randomElement()
                        ?? "🎉 You crushed your water goal today! Keep up the great habit!"
                        TypingEffectView(fullText: randomCongratsMessage)
                            .padding(.top, 15)
                    }
                    
                    else {
                        let randomMessage = hydrationMessages.randomElement() ??
                        "💧 Stay hydrated! Water fuels your energy and focus. 🚀"
                        TypingEffectView(fullText: randomMessage)
                            .padding(.top, 15)
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
    }
    
    private func handleCompletion() {
        triggerConfetti += 1
    }
    
    private func increaseProgress() {
        let newProgress = min(challenge.progress + 0.2, challenge.goal)
        updateChallengeProgress(newProgress)
    }
    
    private func decreaseProgress() {
        let newProgress = max(challenge.progress - 0.2, 0)
        updateChallengeProgress(newProgress)
    }
    
    private func updateChallengeProgress(_ newProgress: CGFloat) {
        challenge.progress = newProgress
        
        mealPlanner.updateWaterChallengeProgress(
            for: date,
            with: newProgress,
            in: challenge.goal
        )
        
        if challenge.alphaProgress() >= 0.99 {
            handleCompletion()
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
        fontSize: CGFloat = 15,
        fontColor: Color = .black.opacity(0.6),
        fontWeight: Font.Weight = .regular,
        aiCoachVisibility: Bool = true
    ) {
        self.fullText = fullText
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.fontWeight = fontWeight
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
        typeNextWord()
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
