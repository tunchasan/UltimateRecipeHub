//
//  HydrationMessageManager.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 23.02.2025.
//

import SwiftUI

class HydrationMessageManager: ObservableObject {
    static let shared = HydrationMessageManager()
    
    private let hydrationKey = "hydrationMessageIndex"
    private let goalSuggestionKey = "goalSuggestionMessageIndex"
    private let goalAchievementKey = "goalAchievementMessagesIndex"
    
    private let progressZeroToHalfKey = "zeroToHalfMessagesIndex"
    private let progressHalfToOneKey = "halfToOneMessagesIndex"
    private let progressOneToOnePointFiveKey = "oneToOnePointFiveMessagesIndex"
    private let progressOnePointFiveToTwoKey = "onePointFiveToTwoMessagesIndex"
    private let progressAboveTwoKey = "aboveTwoMessagesIndex"

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
    
    let waterProgressZeroToHalf: [String] = [
        "Your body is running low on hydration—dehydration can cause fatigue and headaches.",
        "Your body is in dehydration mode—low water intake can lead to fatigue, headaches, and low concentration.",
        "Your muscles, skin, and brain all need more water to function properly—let’s work on building this habit!",
        "Consistently low water intake may be affecting your mood and digestion without you even realizing it.",
        "Schedule small reminders throughout the day to sip water, especially in the morning and afternoon.",
        "Your body is basically running on fumes! Dehydration can cause fatigue, headaches, and make you feel sluggish. 😵‍💫",
        "Uh-oh! Less than 0.5L? Your skin, muscles, and digestion are struggling to keep up! 😨",
        "Water? Never heard of it? Your body has, and it’s BEGGING for some! 🆘",
        "Start small—drink a glass of water first thing in the morning! Your brain will thank you. 🧠💡",
        "You’re sipping, but let’s be real—you can do better! Hydration helps keep your skin glowing. ✨"
    ]
    
    let waterProgressHalfToOne: [String] = [
        "🥤 You’re making progress, but your body still needs more water for optimal energy and focus.",
        "You’re drinking some water, but your body needs more to stay energized and keep your skin hydrated.",
        "Just a little more water can improve your digestion, reduce cravings, and give you more energy.",
        "You’re making progress, but dehydration can still creep up—especially on busy days.",
        "Try drinking a glass of water every time you check your phone—it’s an easy way to build the habit!",
        "Good start, but your cells are still thirsty! Dehydration can sneak up on you and mess with focus.",
        "You’re getting there! But let’s be real—your body needs more than a few sips to function at its best! 🚰",
        "Challenge yourself: Add an extra glass in the afternoon to avoid the 3PM energy crash! ☕➡️💦",
        "Your body is whispering, ‘More water, please!’ Try listening before it starts screaming. 🗣️",
        "Your body is doing its best with what you give it, but a little more H2O would work wonders! 🌊"
    ]
    
    let waterProgressOneToOnePointFive: [String] = [
        "💦 You’re getting close to the ideal hydration range—just a little more can keep you feeling your best!",
        "Your hydration is solid, but drinking slightly more could help with clearer skin and better digestion.",
        "You’re building a healthy hydration habit! Just a slight increase can support better concentration and metabolism.",
        "You’re on the right track, but a little more hydration can further boost digestion and concentration.",
        "Continue this habit and consider adjusting your intake based on exercise and weather conditions.",
        "Nice work! You’re keeping up, but a little extra water can help boost your energy and metabolism. ⚡",
        "You’re at a decent hydration level, but imagine how much better you’d feel with just one more glass! 🏆",
        "Try setting a personal water goal for the week and reward yourself when you hit it! 🎉",
        "You’re at the hydration sweet spot, but on hot days or workout sessions, you might need more! ☀️🏋️",
        "Listen to your body! If you’re sweating more, drink up and keep those electrolytes balanced. ⚖️"
    ]
    
    let waterProgressOnePointFiveToTwo: [String] = [
        "🌊 Continue this habit and consider adjusting your intake based on exercise and weather conditions.",
        "You’re doing a great job staying hydrated! Your body is benefiting from better circulation and digestion.",
        "Drinking enough water can also boost your immune system—hydration plays a bigger role in health than you think!",
        "Stay mindful of hydration balance; ensure you’re also replenishing electrolytes if you’re very active.",
        "Keep up the habit! On workout days, consider adding coconut water 🥥 for extra minerals!",
        "Your hydration game is strong! Staying at this level helps with digestion, focus, and energy. 🏆",
        "Now that you’re doing good on water intake, challenge yourself with a hydration streak! 🔥",
        "Keep up the habit and adjust intake based on exercise or weather changes! ☀️🏃‍♀️",
        "You’re hydrated enough to function well, but more water could keep your joints happy and skin glowing. ✨",
        "Challenge yourself: Try hitting 2L this week and see how you feel! 💙"
    ]
    
    let waterProgressAboveTwo: [String] = [
        "🏆 You’re a hydration pro! Your body is reaping the benefits of better energy, skin health, and digestion.",
        "Your hydration is on point! This habit is likely improving your metabolism and helping your body recover faster.",
        "Drinking over 2L daily is fantastic—your kidneys, skin, and muscles are thanking you!",
        "You’re exceeding daily hydration goals—your body is well-supported for performance and recovery!",
        "You’re a hydration role model—your body is functioning at peak efficiency! 💪",
        "You’re crushing it! Hydration at this level fuels better recovery, digestion, and even skin health! 🌟",
        "Your cells are celebrating—your hydration habits are top-tier! 🎉",
        "Elite hydration status unlocked! 🔓 Your body is running at max efficiency!",
        "You’re exceeding daily hydration goals! That means better muscle recovery, digestion, and focus. 💪",
        "Spread the wisdom—challenge a friend to match your hydration streak! 👯‍♂️"
    ]
    
    func getConclusitionText(for progress: CGFloat) -> String {
        if progress < 0.5 {
            return getNextWaterProgressZeroToHalf()
        }
        
        else if progress >= 0.5 && progress < 1.0 {
            return getNextWaterProgressHalfToOne()
        }
        
        else if progress >= 1 && progress < 1.5 {
            return getNextWaterProgressOneToOnePointFive()
        }
        
        else if progress >= 1.5 && progress < 2 {
            return getNextWaterProgressOnePointFiveToTwo()
        }
        
        return getNextWaterProgressAboveTwo()
    }

    func getNextHydrationMessage() -> String {
        let message = getNextMessage(forKey: hydrationKey, messages: hydrationMessages)
        print("getNextHydrationMessage")
        return message
    }
    
    func getNextGoalSuggestionMessages() -> String {
        let message = getNextMessage(forKey: goalSuggestionKey, messages: goalSuggestionMessages)
        print("getNextGoalSuggestionMessages")
        return message
    }
    
    func getNextWaterGoalAchievementMessages() -> String {
        let message = getNextMessage(forKey: goalAchievementKey, messages: waterGoalAchievementMessages)
        print("getNextWaterGoalAchievementMessages")
        return message
    }
    
    func getNextWaterProgressZeroToHalf() -> String {
        return getNextMessage(forKey: progressZeroToHalfKey, messages: waterProgressZeroToHalf)
    }
    
    func getNextWaterProgressHalfToOne() -> String {
        return getNextMessage(forKey: progressHalfToOneKey, messages: waterProgressHalfToOne)
    }
    
    func getNextWaterProgressOneToOnePointFive() -> String {
        return getNextMessage(forKey: progressOneToOnePointFiveKey, messages: waterProgressOneToOnePointFive)
    }
    
    func getNextWaterProgressOnePointFiveToTwo() -> String {
        return getNextMessage(forKey: progressOnePointFiveToTwoKey, messages: waterProgressOnePointFiveToTwo)
    }
    
    func getNextWaterProgressAboveTwo() -> String {
        return getNextMessage(forKey: progressAboveTwoKey, messages: waterProgressAboveTwo)
    }

    private func getNextMessage(forKey key: String, messages: [String]) -> String {
        let currentIndex = UserDefaults.standard.integer(forKey: key)
        let nextIndex = (currentIndex + 1) % messages.count
        UserDefaults.standard.set(nextIndex, forKey: key)
        return messages[currentIndex]
    }
}
