/// Defines the visual appearance of point markers in ForeFlight.
///
/// IconStyle controls how point geometries appear, including:
/// - The icon (pushpin, circle, diamond, etc.)
/// - The color of the icon
/// - The scale/size of the icon
///
/// ForeFlight supports two icon systems:
/// 1. **Predefined colored shapes** (pushpin, circle, square, diamond) with fixed colors
/// 2. **Custom colored shapes** (triangle, forbidden, target, etc.) with any color
///
public struct IconStyle: KMLSubStyle {
    /// Scale factor for the icon size (1.0 = normal size)
    var scale: Double? = 1.3
    private let iconHrefValue: String
    private let colorValue: KMLColor?

    private init(href: String, color: KMLColor?, scale: Double?) {
        self.iconHrefValue = href
        self.colorValue = color
        self.scale = scale
    }

    /// Create an icon style using Google's predefined colored paddle icons.
    /// These icons have fixed color options but come in common shapes.
    /// - Parameters:
    ///   - type: The shape (pushpin, circle, square, or diamond)
    ///   - color: One of the predefined colors (red, blue, green, etc.)
    ///   - scale: Size multiplier for the icon (default: 1.3)
    /// - Returns: A new IconStyle configured for predefined colored shapes
    public static func predefined(
        type: PredefinedIconType, color: DefinedIconColor, scale: Double? = 1.3
    ) -> IconStyle {
        let baseUrl = "http://maps.google.com/mapfiles/kml/"
        let folder = type == .pushpin ? "pushpin" : "paddle"
        let colorPrefix: String
        if type == .pushpin && color == .blue {
            colorPrefix = "blue"
        } else {
            colorPrefix = color.rawValue
        }
        let href = "\(baseUrl)\(folder)/\(colorPrefix)-\(type).png"
        return IconStyle(href: href, color: nil, scale: scale)
    }

    /// Create an icon style using Google's shape icons with custom colors.
    /// These icons support any KML color but have a different set of available shapes.
    /// - Parameters:
    ///   - type: The shape (triangle, forbidden, target, or opendiamond)
    ///   - color: Any KML color (optional)
    ///   - scale: Size multiplier for the icon (default: 1.3)
    /// - Returns: A new IconStyle configured for custom colored shapes
    public static func custom(type: CustomIconType, color: KMLColor? = nil, scale: Double? = 1.3)
        -> IconStyle {
        let baseUrl = "http://maps.google.com/mapfiles/kml/"
        let href = "\(baseUrl)shapes/\(type.href).png"
        return IconStyle(href: href, color: color, scale: scale)
    }

    func iconHref() -> String {
        return iconHrefValue
    }

    public func kmlString() -> String {
        var lines: [String] = []
        lines.append("<IconStyle>")

        if let color = colorValue {
            lines.append("<color>\(color.kmlHexString)</color>")
        }

        if let scale = self.scale {
            lines.append("<scale>\(scale)</scale>")
        }

        lines.append("<Icon>")
        lines.append("<href>\(iconHref())</href>")
        lines.append("</Icon>")
        lines.append("</IconStyle>")

        return lines.joined(separator: "\n")
    }
}

/// Icon shapes that work with Google's predefined color system.
/// These are the "paddle" style icons that only support fixed colors.
public enum PredefinedIconType: String {
    case pushpin
    case circle
    case square
    case diamond
}

/// Icon shapes that support custom colors.
/// These are the "shapes" style icons that can be any color via KML's color tag.
public enum CustomIconType {
    case opendiamond
    case triangle
    case forbidden
    case target
    case square
    case placemarksquare
    case placemarkcircle

    var href: String {
        switch self {
        case .opendiamond: return "open-diamond"
        case .triangle: return "triangle"
        case .forbidden: return "forbidden"
        case .target: return "target"
        case .square: return "square"
        case .placemarksquare: return "placemark_square"
        case .placemarkcircle: return "placemark_circle"
        }
    }
}

/// Predefined icon colors available for paddle-style icons.
/// These are the standard colors provided by Google's KML icon set.
public enum DefinedIconColor: String {
    case purple = "purple"
    case white = "wht"
    case green = "grn"
    case yellow = "ylw"
    case blue = "blu"
    case lightblue = "ltblu"
    case pink = "pink"
    case red = "red"
}
