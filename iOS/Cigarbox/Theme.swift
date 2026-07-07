import SwiftUI

/// Unique palette for Cigarbox: cedar humidor brown.
enum Theme {
    static let accent = Color(hex: "#8C6A3F")
    static let background = Color(hex: "#120F0B")
    static let surface = Color(hex: "#1E1912")
    static let textPrimary = Color(hex: "#F0E6D6")
    static let textMuted = Color(hex: "#A99878")

    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
