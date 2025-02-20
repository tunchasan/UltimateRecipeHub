//
//  OnboardingHealtyMealPage 2.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 20.02.2025.
//

import SwiftUI

struct OnboardingAICoachPage: View {
    
    var action: () -> Void
    
    var body: some View {
        
        VStack(spacing: 60) {
            Text(formattedText())
                .multilineTextAlignment(.center)
            
            VStack(spacing: 20) {
                Image("Onboarding AI Coach")
                    .resizable()
                    .scaledToFit() // Keeps aspect ratio
                    .frame(width: UIScreen.main.bounds.width * 1.1, alignment: .leading) // 90% of screen width
                    .clipped() // Ensures it doesn't overflow
                
                OnboardTypingEffectView()
            }
            
            VStack(spacing: 20) {
                RoundedButton(
                    title: "Let's Start",
                    maxWidth: 150
                ) {
                    action()
                }
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(Color.green.opacity(0.8))
                        .frame(width: 10, height: 10)
                }
            }
        }
    }
    
    private func formattedText() -> AttributedString {
        
        var numberText = AttributedString("AI Coach")
        numberText.foregroundColor = .purple
        numberText.font = .system(size: 36).bold()
        
        var remainedText = AttributedString(" is here to\nguide you in your\nnew journey")
        remainedText.foregroundColor = .black
        remainedText.font = .system(size: 32).bold()
        
        return numberText + remainedText
    }
    
    func formatAttributedString(for text: String) -> AttributedString {
        var attributedString = AttributedString("")
        
        // Split text into words
        let words = text.components(separatedBy: " ")
        
        for (index, word) in words.enumerated() {
            var wordAttr = AttributedString(word)
            
            // Ensure the word is not empty
            if !word.isEmpty {
                let firstLetterRange = wordAttr.characters.startIndex..<wordAttr.characters.index(after: wordAttr.characters.startIndex)
                
                // Apply green color and bold font to the first letter
                wordAttr[firstLetterRange].foregroundColor = .green
                wordAttr[firstLetterRange].font = .body.bold()
            }
            
            // Append formatted word to the main attributed string
            attributedString += wordAttr
            
            // Add a space after each word except the last one
            if index < words.count - 1 {
                attributedString += AttributedString(" ")
            }
        }
        
        return attributedString
    }}

#Preview {
    OnboardingAICoachPage(action: {})
}

struct OnboardTypingEffectView: View {
    
    let fullText: String
    private let words: [String]
    
    @State private var displayedText: AttributedString = ""
    @State private var currentWordIndex = 0
    
    var body: some View {
        Text(displayedText)
            .lineSpacing(4)
            .multilineTextAlignment(.center)
            .onAppear {
                typeNextWord()
            }
    }
    
    init() {
        self.fullText = "Hey! I’m your AI Coach—here to keep you\nenergized with smart tips on hydration,\nmeals, and wellness. Let’s crush\nyour health goals together!"
        self.words = fullText.components(separatedBy: " ")
    }
    
    private func typeNextWord() {
        guard currentWordIndex < words.count else { return }
        
        let delay = Double.random(in: 0.15...0.3)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: delay)) {
                
                var newWord = AttributedString("\(self.words[self.currentWordIndex]) ")
                newWord.foregroundColor = .black
                newWord.font = .system(size: 18)
                
                // Check if "AI Coach" exists in the new word and apply purple styling
                if let range = newWord.range(of: "AI") {
                    newWord[range].foregroundColor = .purple
                    newWord[range].font = .system(size: 20).bold()
                }
                
                if let range = newWord.range(of: "Coach") {
                    newWord[range].foregroundColor = .purple
                    newWord[range].font = .system(size: 20).bold()
                }
                
                displayedText += newWord
            }
            
            // Haptic feedback for each typed word
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            currentWordIndex += 1
            typeNextWord() // Recursively call to add the next word
        }
    }
}
