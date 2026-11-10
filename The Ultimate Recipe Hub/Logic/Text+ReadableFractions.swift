import SwiftUI

extension Text {
    /// The amount with ½ ⅓ ⅔ ¼ ¾ ⅛ ⅜ ⅝ ⅞ drawn 35% larger than the digits around them: at the same size as the
    /// digits these single-character fractions are too small to read ("1½ cups" → the ½ matches the 1).
    static func withReadableFractions(_ string: String, size: CGFloat, weight: Font.Weight) -> Text {
        let fractions: Set<Character> = ["½", "⅓", "⅔", "¼", "¾", "⅛", "⅜", "⅝", "⅞"]
        var result = Text("")
        var run = ""
        for character in string {
            if fractions.contains(character) {
                if !run.isEmpty {
                    result = result + Text(run).font(.system(size: size, weight: weight))
                    run = ""
                }
                result = result + Text(String(character)).font(.system(size: size * 1.35, weight: weight))
            } else {
                run.append(character)
            }
        }
        if !run.isEmpty {
            result = result + Text(run).font(.system(size: size, weight: weight))
        }
        return result
    }
}
