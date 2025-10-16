#if canImport(UIKit)
    import UIKit

    extension KMLColor {
        /// Create KMLColor from UIColor
        /// - Parameter uiColor: UIColor to convert
        /// - Returns: KMLColor representation
        public static func fromUIColor(_ uiColor: UIColor) -> KMLColor {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            return fromRGB(
                red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
        }

        /// Convert to UIColor
        /// - Returns: UIColor representation
        public func toUIColor() -> UIColor {
            return UIColor(
                red: CGFloat(r),
                green: CGFloat(g),
                blue: CGFloat(b),
                alpha: CGFloat(a)
            )
        }
    }
#endif

#if canImport(AppKit)
    import AppKit

    extension KMLColor {
        /// Create KMLColor from NSColor
        /// - Parameter nsColor: NSColor to convert
        /// - Returns: KMLColor representation
        public static func fromNSColor(_ nsColor: NSColor) -> KMLColor {
            let converted = nsColor.usingColorSpace(.sRGB) ?? nsColor
            return fromRGB(
                red: Double(converted.redComponent),
                green: Double(converted.greenComponent),
                blue: Double(converted.blueComponent),
                alpha: Double(converted.alphaComponent)
            )
        }

        /// Convert to NSColor
        /// - Returns: NSColor representation
        public func toNSColor() -> NSColor {
            return NSColor(
                red: CGFloat(r),
                green: CGFloat(g),
                blue: CGFloat(b),
                alpha: CGFloat(a)
            )
        }
    }
#endif
