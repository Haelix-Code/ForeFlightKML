import Foundation

public struct KMLColor: Equatable, CustomStringConvertible {
    public var description: String { kmlHexString }

    /// Single internal storage: bits [31..24]=A, [23..16]=R, [15..8]=G, [7..0]=B
    private let value: UInt32

    /// Channel values as Int 0..255
    private var aInt: Int { Int((value >> 24) & 0xFF) }
    private var rInt: Int { Int((value >> 16) & 0xFF) }
    private var gInt: Int { Int((value >> 8) & 0xFF) }
    private var bInt: Int { Int(value & 0xFF) }

    /// Channel values as Double 0.0..1.0
    internal var a: Double { Double(aInt) / 255.0 }
    internal var r: Double { Double(rInt) / 255.0 }
    internal var g: Double { Double(gInt) / 255.0 }
    internal var b: Double { Double(bInt) / 255.0 }

    /// Initialize with single internal UInt32 in AARRGGBB order.
    private init(value: UInt32) {
        self.value = value
    }

    /// Initialize from 0..255 integer channels. Values are clamped to 0..255.
    private init(r: Int, g: Int, b: Int, a: Int = 255) {
        func clampByte(_ x: Int) -> UInt32 {
            let v = max(0, min(255, x))
            return UInt32(v & 0xFF)
        }
        let av = clampByte(a) << 24
        let rv = clampByte(r) << 16
        let gv = clampByte(g) << 8
        let bv = clampByte(b)
        self.value = av | rv | gv | bv
    }

    /// Create a color from RGB values (0-255) with optional alpha
    /// - Parameters:
    ///   - red: Red component (0-255, will be clamped)
    ///   - green: Green component (0-255, will be clamped)
    ///   - blue: Blue component (0-255, will be clamped)
    ///   - alpha: Alpha component (0-255, will be clamped). Default is 255 (opaque)
    /// - Returns: A new KMLColor
    public static func fromRGB(red: Int, green: Int, blue: Int, alpha: Int = 255) -> KMLColor {
        return KMLColor(r: red, g: green, b: blue, a: alpha)
    }

    /// Create a color from normalized RGB values (0.0-1.0) with optional alpha
    /// - Parameters:
    ///   - red: Red component (0.0-1.0, will be clamped)
    ///   - green: Green component (0.0-1.0, will be clamped)
    ///   - blue: Blue component (0.0-1.0, will be clamped)
    ///   - alpha: Alpha component (0.0-1.0, will be clamped). Default is 1.0 (opaque)
    /// - Returns: A new KMLColor
    public static func fromRGB(red: Double, green: Double, blue: Double, alpha: Double = 1.0)
        -> KMLColor {
        func clampAndScale(_ value: Double) -> Int {
            Int((max(0.0, min(1.0, value)) * 255.0).rounded())
        }

        return KMLColor(
            r: clampAndScale(red),
            g: clampAndScale(green),
            b: clampAndScale(blue),
            a: clampAndScale(alpha)
        )
    }

    /// Create a color from a hex string
    /// - Parameter hex: Hex string in format "#RGB", "#RRGGBB", "#AARRGGBB", "RGB", "RRGGBB", or "AARRGGBB"
    /// - Returns: Result containing KMLColor
    public static func fromHex(_ hex: String) -> KMLColor {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()

        // Validate hex characters
        let hexCharSet = CharacterSet(charactersIn: "0123456789ABCDEF")
        guard cleaned.unicodeScalars.allSatisfy({ hexCharSet.contains($0) }) else {
            return .black
        }

        switch cleaned.count {
        case 3:
            // RGB -> RRGGBB (expand each digit)
            guard let r = Int(String(cleaned[cleaned.startIndex]), radix: 16),
                let g = Int(
                    String(cleaned[cleaned.index(cleaned.startIndex, offsetBy: 1)]), radix: 16),
                let b = Int(
                    String(cleaned[cleaned.index(cleaned.startIndex, offsetBy: 2)]), radix: 16)
            else {
                return .black
            }
            return KMLColor(r: r * 17, g: g * 17, b: b * 17, a: 255)

        case 6:
            // RRGGBB
            guard
                let r = Int(
                    cleaned[cleaned.startIndex..<cleaned.index(cleaned.startIndex, offsetBy: 2)],
                    radix: 16),
                let g = Int(
                    cleaned[
                        cleaned.index(
                            cleaned.startIndex, offsetBy: 2)..<cleaned.index(
                                cleaned.startIndex, offsetBy: 4)], radix: 16),
                let b = Int(
                    cleaned[
                        cleaned.index(
                            cleaned.startIndex, offsetBy: 4)..<cleaned.index(
                                cleaned.startIndex, offsetBy: 6)], radix: 16)
            else {
                return .black
            }
            return KMLColor(r: r, g: g, b: b, a: 255)

        case 8:
            // AARRGGBB
            guard
                let a = Int(
                    cleaned[cleaned.startIndex..<cleaned.index(cleaned.startIndex, offsetBy: 2)],
                    radix: 16),
                let r = Int(
                    cleaned[
                        cleaned.index(
                            cleaned.startIndex, offsetBy: 2)..<cleaned.index(
                                cleaned.startIndex, offsetBy: 4)], radix: 16),
                let g = Int(
                    cleaned[
                        cleaned.index(
                            cleaned.startIndex, offsetBy: 4)..<cleaned.index(
                                cleaned.startIndex, offsetBy: 6)], radix: 16),
                let b = Int(
                    cleaned[
                        cleaned.index(
                            cleaned.startIndex, offsetBy: 6)..<cleaned.index(
                                cleaned.startIndex, offsetBy: 8)], radix: 16)
            else {
                return .black
            }
            return KMLColor(r: r, g: g, b: b, a: a)

        default:
            return .black
        }
    }

    /// Create a color from KML hex format (aabbggrr)
    /// - Parameter kmlHex: Hex string in KML format "aabbggrr"
    /// - Returns: Result containing KMLColor
    public static func fromKMLHex(_ kmlHex: String) -> KMLColor {
        let cleaned = kmlHex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()

        guard cleaned.count == 8 else {
            return .black
        }

        // Validate hex characters
        let hexCharSet = CharacterSet(charactersIn: "0123456789ABCDEF")
        guard cleaned.unicodeScalars.allSatisfy({ hexCharSet.contains($0) }) else {
            return .black
        }

        // Parse aabbggrr -> a, b, g, r
        guard
            let a = Int(
                cleaned[cleaned.startIndex..<cleaned.index(cleaned.startIndex, offsetBy: 2)],
                radix: 16),
            let b = Int(
                cleaned[
                    cleaned.index(
                        cleaned.startIndex, offsetBy: 2)..<cleaned.index(
                            cleaned.startIndex, offsetBy: 4)], radix: 16),
            let g = Int(
                cleaned[
                    cleaned.index(
                        cleaned.startIndex, offsetBy: 4)..<cleaned.index(
                            cleaned.startIndex, offsetBy: 6)], radix: 16),
            let r = Int(
                cleaned[
                    cleaned.index(
                        cleaned.startIndex, offsetBy: 6)..<cleaned.index(
                            cleaned.startIndex, offsetBy: 8)], radix: 16)
        else {
            return .black
        }

        return KMLColor(r: r, g: g, b: b, a: a)
    }

    public var kmlHexString: String {
        String(format: "%02x%02x%02x%02x", aInt, bInt, gInt, rInt)
    }

    /// Returns a new color with modified alpha
    /// - Parameter alpha: New alpha value (0-255, will be clamped)
    /// - Returns: New KMLColor with updated alpha
    public func withAlpha(_ alpha: Int) -> KMLColor {
        return KMLColor(r: rInt, g: gInt, b: bInt, a: alpha)
    }

    /// Returns a new color with modified alpha
    /// - Parameter alpha: New alpha value (0.0-1.0, will be clamped)
    /// - Returns: New KMLColor with updated alpha
    public func withAlpha(_ alpha: Double) -> KMLColor {
        let alphaInt = Int((max(0.0, min(1.0, alpha)) * 255.0).rounded())
        return withAlpha(alphaInt)
    }

    public enum KMLColorError: Error, LocalizedError {
        case invalidHexFormat(String)
        case invalidKMLHexFormat(String)

        public var errorDescription: String? {
            switch self {
            case .invalidHexFormat(let hex):
                return
                    "Invalid hex color format: '\(hex)'. Expected formats: RGB, RRGGBB, AARRGGBB (with optional # prefix)"
            case .invalidKMLHexFormat(let hex):
                return
                    "Invalid KML hex color format: '\(hex)'. Expected format: aabbggrr (8 hex characters)"
            }
        }
    }

    public static let black = KMLColor(r: 0, g: 0, b: 0, a: 255)
    public static let white = KMLColor(r: 255, g: 255, b: 255, a: 255)
    public static let clear = KMLColor(r: 0, g: 0, b: 0, a: 0)
    public static let warning = KMLColor(r: 255, g: 0, b: 0)
    public static let caution = KMLColor(r: 255, g: 214, b: 10)
    public static let advisory = KMLColor(r: 48, g: 209, b: 88)
}
