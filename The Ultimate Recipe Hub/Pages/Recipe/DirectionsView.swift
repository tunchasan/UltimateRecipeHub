//
//  DirectionsView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct DirectionsView: View {
    var ingredientKeywords: [String]
    @State var directions: [String]
    /// Step text, and its highlighted ingredients
    private let stepFontSize: CGFloat = 17
    
    var body: some View {
        // Highlighted once per recipe and kept, not on every redraw
        let steps = IngredientMentions.highlightedSteps(directions, ingredientNames: ingredientKeywords, fontSize: stepFontSize)
        
        VStack(alignment: .leading, spacing: 20) {
            // Title for Directions Section
            Text("Directions")
                .font(.title3.bold())
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Steps List
            ForEach(directions.indices.dropLast(), id: \.self) { index in
                HStack(alignment: .firstTextBaseline) {
                    // Step Number
                    Text("\(index + 1)")
                        .font(.subheadline.bold())
                        .foregroundColor(.black)
                        .frame(width: 25, height: 25) // Circle size
                        .background(
                            Circle()
                                .fill(Color.green.opacity(0.2)) // White background
                        )
                    
                    // Step Description with Highlighted Keywords
                    Text(steps[index])
                        .font(.system(size: stepFontSize))
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                }
                .padding(.horizontal)
            }
        }
    }
}

/// Highlighted steps kept in an NSCache, which only holds objects.
private final class HighlightedStepsBox {
    let steps: [AttributedString]
    init(_ steps: [AttributedString]) { self.steps = steps }
}

// MARK: - Ingredient mentions in the directions

/// Finds a recipe's ingredients in its direction steps: whole words only, the longest name first, every mention.
/// "Heat the olive oil" → "olive oil"; "Bring to a boil" → nothing (not the "oil" in "boil").
/// Describing words count inside a name ("black pepper", "sea salt"), never on their own ("brown the beef").
enum IngredientMentions {

    /// Built once per recipe and kept.
    private static let cache: NSCache<NSString, NSRegularExpression> = {
        let newCache = NSCache<NSString, NSRegularExpression>()
        newCache.countLimit = 50
        return newCache
    }()

    static func regex(for ingredientNames: [String]) -> NSRegularExpression? {
        let cacheKey = ingredientNames.joined(separator: "\n") as NSString
        if let cached = cache.object(forKey: cacheKey) { return cached }

        var wordCountByAlternative: [String: Int] = [:]
        for name in ingredientNames {
            for phrase in phrases(in: name) {
                if let regexAlternative = alternative(for: phrase) {
                    wordCountByAlternative[regexAlternative] = phrase.count
                }
            }
        }
        guard !wordCountByAlternative.isEmpty else { return nil }

        // More words first, then longer: "red pepper flakes" before "red pepper" before "pepper"
        let ordered = wordCountByAlternative.keys.sorted { lhs, rhs in
            let lhsWords = wordCountByAlternative[lhs] ?? 0
            let rhsWords = wordCountByAlternative[rhs] ?? 0
            if lhsWords != rhsWords { return lhsWords > rhsWords }
            if lhs.count != rhs.count { return lhs.count > rhs.count }
            return lhs < rhs
        }
        // Whole words only: not the "oil" in "boil" or the "egg" in "eggplant"
        let fullPattern = "(?<![\\w'’])(?:" + ordered.joined(separator: "|") + ")(?![\\w'’])"
        guard let compiled = try? NSRegularExpression(pattern: fullPattern, options: [.caseInsensitive]) else { return nil }
        cache.setObject(compiled, forKey: cacheKey)
        return compiled
    }

    // MARK: Highlighting steps

    /// Kept per recipe and text size: the recipe and cooking pages can redraw many times.
    private static let stepsCache: NSCache<NSString, HighlightedStepsBox> = {
        let newCache = NSCache<NSString, HighlightedStepsBox>()
        newCache.countLimit = 50
        return newCache
    }()

    /// The steps with their ingredients in orange bold, at the size the page shows them:
    /// "Heat the olive oil" → "olive oil"; "Bring to a boil" → nothing.
    static func highlightedSteps(_ steps: [String], ingredientNames: [String], fontSize: CGFloat) -> [AttributedString] {
        let cacheKey = (["\(fontSize)"] + ingredientNames + ["\u{1E}"] + steps).joined(separator: "\u{1F}") as NSString
        if let cached = stepsCache.object(forKey: cacheKey) { return cached.steps }
        let mentions = regex(for: ingredientNames)
        let highlighted = steps.map { highlight($0, using: mentions, fontSize: fontSize) }
        stepsCache.setObject(HighlightedStepsBox(highlighted), forKey: cacheKey)
        return highlighted
    }

    private static func highlight(_ sentence: String, using mentions: NSRegularExpression?, fontSize: CGFloat) -> AttributedString {
        guard let mentions else { return AttributedString(sentence) }
        var result = AttributedString()
        var position = sentence.startIndex
        let fullRange = NSRange(sentence.startIndex..<sentence.endIndex, in: sentence)
        for match in mentions.matches(in: sentence, range: fullRange) {
            guard let range = Range(match.range, in: sentence), range.lowerBound >= position else { continue }
            result += AttributedString(String(sentence[position..<range.lowerBound]))
            var mention = AttributedString(String(sentence[range]))
            mention.foregroundColor = .orange
            mention.font = .system(size: fontSize).bold()
            result += mention
            position = range.upperBound
        }
        result += AttributedString(String(sentence[position...]))
        return result
    }

    // MARK: Reading an ingredient name

    /// "Extra-virgin olive oil, divided" → olive oil, extra-virgin olive oil, olive, oil (not "extra-virgin" alone).
    private static func phrases(in name: String) -> Set<[String]> {
        let text = name.lowercased()
            .replacingOccurrences(of: "&", with: " and ")
            .replacingOccurrences(of: "’", with: "'")
        let nsText = text as NSString
        let fullRange = NSRange(location: 0, length: nsText.length)

        // A bracket can hold another name for it: "Chevre (goat cheese)", "(e.g., dried fruit, chocolate chips)"
        var bracketParts: [String] = []
        for match in bracketRegex.matches(in: text, range: fullRange) {
            var inner = nsText.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespacesAndNewlines)
            if inner.hasPrefix("e.g") {
                inner = String(inner.dropFirst(3)).trimmingCharacters(in: CharacterSet(charactersIn: ". ,"))
            }
            guard let firstCharacter = inner.first, !firstCharacter.isNumber, !isNote(inner) else { continue }
            bracketParts += inner.components(separatedBy: ",")
        }

        var result = Set<[String]>()
        var foundName = false
        let mainText = bracketRegex.stringByReplacingMatches(in: text, range: fullRange, withTemplate: " ")
        for rawPart in mainText.components(separatedBy: ",") {
            let part = rawPart.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !part.isEmpty, !isNote(part) else { continue }
            if foundName {
                addAlternativeName(part, to: &result)       // "…, or greek yogurt", "Pecorino, Parmesan"
                continue
            }
            // The first part with an ingredient word is the name: "bone-in, skin-on chicken thighs"
            let runs = wordRuns(tokens(in: part))
            guard runs.contains(where: { $0.contains(where: isIngredientWord) }) else { continue }
            foundName = true
            addSubphrases(of: runs, to: &result)
        }
        for part in bracketParts {
            addAlternativeName(part, to: &result)
        }
        return result
    }

    /// Another name for the same ingredient: "or greek yogurt", "Pecorino", "(goat cheese)", "(spinach or arugula)".
    /// Not an instruction: "seeds removed for milder flavor", "kernels cut from the cob", "juices reserved".
    private static func addAlternativeName(_ rawPart: String, to result: inout Set<[String]>) {
        let part = rawPart.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !part.isEmpty, !isNote(part) else { return }
        let partTokens = tokens(in: part)
        for (index, token) in partTokens.enumerated() where looksLikePreparation(token.word) {
            let isLast = index == partTokens.count - 1
            if isLast || joiningWords.contains(partTokens[index + 1].word) { return }
        }
        for chunk in pieces(of: part, splitBy: alternativeSeparator) {
            var chunkTokens = tokens(in: chunk)[...]
            while let firstToken = chunkTokens.first, leadingSkipWords.contains(firstToken.word) {
                chunkTokens = chunkTokens.dropFirst()                // "other small pasta" → "small pasta"
            }
            guard !chunkTokens.isEmpty,
                  !chunkTokens.contains(where: { joiningWords.contains($0.word) || $0.word.count < 2 }),
                  chunkTokens.dropFirst().allSatisfy({ $0.joinsPrevious }) else { continue }
            addSubphrases(of: [chunkTokens.map { $0.word }], to: &result)
        }
    }

    /// Every part of a name that has an ingredient word: [black, pepper] → "black pepper", "pepper" (not "black").
    private static func addSubphrases(of runs: [[String]], to result: inout Set<[String]>) {
        for run in runs {
            for start in run.indices {
                for end in (start + 1)...min(run.count, start + 6) {
                    let phrase = Array(run[start..<end])
                    if phrase.contains(where: isIngredientWord) { result.insert(phrase) }
                }
            }
        }
    }

    // MARK: Words

    private struct Token {
        let word: String
        /// Only spaces since the previous word: "olive oil" yes; "salt/pepper", "2 1/2" no.
        let joinsPrevious: Bool
    }

    private static func tokens(in text: String) -> [Token] {
        let nsText = text as NSString
        var result: [Token] = []
        var previousEnd = 0
        for match in wordRegex.matches(in: text, range: NSRange(location: 0, length: nsText.length)) {
            let gap = nsText.substring(with: NSRange(location: previousEnd, length: match.range.location - previousEnd))
            result.append(Token(word: nsText.substring(with: match.range),
                                joinsPrevious: gap.trimmingCharacters(in: .whitespaces).isEmpty))
            previousEnd = match.range.location + match.range.length
        }
        return result
    }

    /// Words that belong together, split at joining words and punctuation:
    /// "kosher salt and freshly ground black pepper" → [kosher, salt], [freshly, ground, black, pepper]
    private static func wordRuns(_ wordTokens: [Token]) -> [[String]] {
        var runs: [[String]] = []
        var run: [String] = []
        for token in wordTokens {
            let breaksRun = joiningWords.contains(token.word) || token.word.count < 2
            if !token.joinsPrevious || breaksRun {
                if !run.isEmpty { runs.append(run) }
                run = []
                if breaksRun { continue }
            }
            run.append(token.word)
        }
        if !run.isEmpty { runs.append(run) }
        return runs
    }

    /// "chicken", "oil": not "and", "black", "chopped" or "cooking".
    private static func isIngredientWord(_ word: String) -> Bool {
        word.count >= 3 && !joiningWords.contains(word) && !describingWords.contains(word) && !looksLikePreparation(word)
    }

    /// "sliced", "finely", "cooking": not "seed", "jelly" or "dressing".
    private static func looksLikePreparation(_ word: String) -> Bool {
        guard word.count > 4 else { return false }
        if word.hasSuffix("ed") && !word.hasSuffix("eed") { return true }
        if word.hasSuffix("ly") && word != "jelly" && word != "belly" { return true }
        if word.count > 5 && word.hasSuffix("ing") && !foodsEndingInIng.contains(word) { return true }
        return false
    }

    private static func isNote(_ text: String) -> Bool {
        notePrefixes.contains { text.hasPrefix($0) }
    }

    // MARK: Building the expression

    /// "olive oil" → olive[\s-]+(?:oils|oil). "extra-virgin" also matches "extra virgin".
    private static func alternative(for phrase: [String]) -> String? {
        guard let lastWord = phrase.last else { return nil }
        let lastWordForms = "(?:" + forms(of: lastWord).map(wordPattern).joined(separator: "|") + ")"
        return (phrase.dropLast().map(wordPattern) + [lastWordForms]).joined(separator: "[\\s-]+")
    }

    private static func wordPattern(_ word: String) -> String {
        word.split(separator: "-")
            .map { NSRegularExpression.escapedPattern(for: String($0)) }
            .joined(separator: "[\\s-]+")
    }

    /// The word as written plus its singular or plural: eggs/egg, tomato/tomatoes, berries/berry, bay leaf/leaves.
    private static func forms(of word: String) -> [String] {
        var result: Set<String> = [word]
        var candidates: [String] = []
        if word.count > 4 && word.hasSuffix("ies") {
            candidates = [String(word.dropLast(3)) + "y", String(word.dropLast()), String(word.dropLast(2))]  // berry, cookie, chili
        } else if word.hasSuffix("oes") {
            candidates = [String(word.dropLast(2))]                                       // tomato
        } else if ["ches", "shes", "sses", "xes", "zes"].contains(where: { word.hasSuffix($0) }) {
            candidates = [String(word.dropLast(2))]                                       // peach, radish
        } else if word.hasSuffix("s") && !word.hasSuffix("ss") && word.count > 3 {
            candidates = [String(word.dropLast())]                                        // egg
        } else {
            result.insert(plural(of: word))                                              // eggs
            if word.hasSuffix("o") { result.insert(word + "s") }                        // tomatos
        }
        for candidate in candidates where !describingWords.contains(candidate) {
            result.insert(candidate)                                                     // not "greens" → "green"
        }
        if let irregular = irregularForms[word] { result.insert(irregular) }
        return result.sorted { $0.count != $1.count ? $0.count > $1.count : $0 < $1 }
    }

    private static func plural(of word: String) -> String {
        if word.hasSuffix("y"), word.count >= 2, !"aeiou".contains(word[word.index(word.endIndex, offsetBy: -2)]) {
            return String(word.dropLast()) + "ies"                                       // berry → berries
        }
        if ["s", "x", "z", "ch", "sh", "o"].contains(where: { word.hasSuffix($0) }) { return word + "es" }
        return word + "s"
    }

    /// "or tubetti" → ["", "tubetti"]
    private static func pieces(of text: String, splitBy separator: NSRegularExpression) -> [String] {
        let nsText = text as NSString
        var result: [String] = []
        var start = 0
        for match in separator.matches(in: text, range: NSRange(location: 0, length: nsText.length)) {
            result.append(nsText.substring(with: NSRange(location: start, length: match.range.location - start)))
            start = match.range.location + match.range.length
        }
        result.append(nsText.substring(from: start))
        return result
    }

    private static let wordRegex = try! NSRegularExpression(pattern: "\\p{L}[\\p{L}'\\-]*")
    private static let bracketRegex = try! NSRegularExpression(pattern: "\\(([^)]*)\\)")
    private static let alternativeSeparator = try! NSRegularExpression(pattern: "(?:^|\\s+)(?:or|and|like|such as)\\s+")

    // MARK: Word lists

    /// Never part of a name: "salt and pepper", "cut into cubes", "1 cup", "not cilantro".
    private static let joiningWords: Set<String> = [
        "a", "about", "additional", "after", "also", "an", "and", "any", "approximately", "as", "at", "before",
        "bite", "bite-size", "bite-sized", "brand", "bunch", "but", "can", "cans", "choice", "cup", "cups", "cut",
        "dash", "depending", "desired", "divided", "dozen", "each", "eight", "etc", "except", "few", "five", "for",
        "four", "from", "garnish", "garnishing", "gram", "grams", "handful", "if", "in", "inch", "inches",
        "including", "into", "its", "jar", "just", "keep", "kept", "kind", "like", "made", "make", "mix-ins", "more",
        "needed", "nine", "nor", "not", "note", "of", "off", "on", "one", "only", "option", "optional", "or", "other",
        "ounce", "ounces", "out", "over", "package", "packages", "per", "pinch", "plus", "pound", "pounds",
        "preferably", "quarter", "remove", "reserve", "reserving", "see", "serve", "serving", "seven", "six", "size",
        "some", "such", "tablespoon", "tablespoons", "taste", "tbsp", "teaspoon", "teaspoons", "ten", "than", "that",
        "the", "their", "then", "these", "this", "those", "three", "to", "too", "tsp", "two", "type", "under",
        "until", "up", "use", "used", "using", "variety", "very", "via", "well", "when", "which", "while", "with",
        "within", "without", "your"
    ]

    /// Describe an ingredient: highlighted inside a name ("black pepper", "sea salt"), never alone ("brown the beef").
    private static let describingWords: Set<String> = [
        "all-purpose", "american", "asian", "baking", "beaten", "best", "big", "black", "boiled", "bone", "bone-in",
        "boneless", "bones", "bottoms", "broken", "brown", "cake", "canned", "chinese", "chopped", "chunks", "clove",
        "coarse", "coarsely", "cold", "combination", "cooked", "cored", "crisp", "crispy", "crosswise", "crunchy",
        "crushed", "cube", "cubed", "cubes", "curly", "dark", "day-old", "deveined", "dice", "diced", "drained",
        "dried", "dry", "ears", "ends", "english", "extra", "extra-virgin", "fat", "favorite", "fine", "finely",
        "firm", "flaky", "flat-leaf", "free", "french", "fresh", "freshly", "frozen", "fry", "full", "fully",
        "generous", "golden", "good", "grated", "great", "greek", "green", "ground", "half", "halved", "halves",
        "head", "heads", "heaping", "heat", "homemade", "hot", "inch-long", "inch-thick", "inch-wide", "indian",
        "italian", "japanese", "juiced", "korean", "kosher", "large", "leaf", "leafy", "leaves", "lengthwise",
        "level", "light", "long", "loosely", "low", "low-sodium", "lukewarm", "matchsticks", "mediterranean",
        "medium", "melted", "mexican", "mild", "minced", "mix", "mixture", "new", "old", "packed", "pale", "part",
        "parts", "peeled", "persian", "pie", "piece", "pieces", "plain", "pounded", "quality", "quartered",
        "quarters", "raw", "red", "reduced", "regular", "ribbons", "rinsed", "ripe", "roast", "room",
        "room-temperature", "roughly", "rounds", "salted", "scant", "sea", "seeded", "separated", "short", "shredded",
        "sifted", "sized", "skin", "skin-on", "skinless", "slice", "sliced", "slices", "small", "soft", "softened",
        "spanish", "spicy", "sprig", "sprigs", "stalk", "stalks", "stems", "stew", "stick", "sticks", "store-bought",
        "strips", "style", "sweet", "temperature", "tender", "thai", "thawed", "thick", "thick-cut", "thickly",
        "thin", "thinly", "tightly", "toasted", "tops", "torn", "trimmed", "uncooked", "unsalted", "unsweetened",
        "vegan", "vegetarian", "virgin", "warm", "wedges", "wet", "white", "whites", "whole", "yellow", "zested"
    ]

    /// A part of the name that is a note, not the ingredient: ", to taste", "(optional)", "(not cilantro!)".
    private static let notePrefixes = [
        "for ", "to taste", "to serve", "to garnish", "plus ", "optional", "divided", "as needed", "as desired",
        "if desired", "if needed", "or more", "about ", "e.g", "such as", "at room", "see ", "note", "not ",
        "reserve "
    ]

    /// Skipped at the start of another name: "or other small pasta" → "small pasta".
    private static let leadingSkipWords: Set<String> = ["a", "an", "any", "other", "preferably", "some", "the"]

    private static let foodsEndingInIng: Set<String> = [
        "dressing", "dumpling", "filling", "frosting", "herring", "icing", "pudding", "seasoning", "spring", "string",
        "stuffing", "whiting"
    ]

    private static let irregularForms = [
        "leaves": "leaf", "leaf": "leaves", "halves": "half", "half": "halves", "loaves": "loaf", "loaf": "loaves"
    ]
}
