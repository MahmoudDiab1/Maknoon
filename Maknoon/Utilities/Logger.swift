import Foundation
import os.log

// MARK: - Logger Extension
extension Logger {
    private func decodeUnicode(_ text: String) -> String {
        let pattern = "\\\\u[0-9a-fA-F]{4}"
        let regex = try? NSRegularExpression(pattern: pattern)
        var result = text
        
        if let matches = regex?.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
            for match in matches.reversed() {
                if let range = Range(match.range, in: text) {
                    let unicodeStr = String(text[range])
                    if let unicodeValue = UInt32(unicodeStr.dropFirst(2), radix: 16),
                       let scalar = UnicodeScalar(unicodeValue) {
                        result = result.replacingCharacters(in: range, with: String(scalar))
                    }
                }
            }
        }
        return result
    }
    
    func debugArabic(_ message: String, _ text: String) {
        let decodedText = decodeUnicode(text)
        debug("\(message): \(decodedText)")
    }
    
    func infoArabic(_ message: String, _ text: String) {
        let decodedText = decodeUnicode(text)
        info("\(message): \(decodedText)")
    }
    
    func errorArabic(_ message: String, _ text: String) {
        let decodedText = decodeUnicode(text)
        error("\(message): \(decodedText)")
    }
} 