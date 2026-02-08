import Foundation

/// A complete visual style that can be applied to placemarks.
///
/// Style combines multiple sub-styles to define the complete appearance:
/// - IconStyle: For point markers
/// - LineStyle: For line colors and widths
/// - PolyStyle: For polygon fills
/// - LabelStyle: For text labels
///
/// Styles are automatically registered with the KML document and can be reused
/// across multiple placemarks for consistency and smaller file sizes.
///
///
internal struct Style: KMLStyle {
    var subStyles: [KMLSubStyle] = []
    var styleId: String

    public func id() -> String {
        return styleId
    }

    var requiresKMZ: Bool {
        subStyles.contains {
            ($0 as? IconStyle)?.requiresKMZ == true
        }
    }

    /// Create a new complete style.
    /// - Parameters:
    ///   - subStyles: Array of style components to combine
    ///   - styleId: Unique identifier (auto-generated if not provided)
    public init(subStyles: [KMLSubStyle], styleId: String = "s-\(UUID().uuidString)") {
        self.subStyles = subStyles
        self.styleId = styleId
    }

    public func write(to buffer: inout String) {
        buffer.append("<Style id=\"\(self.id())\">\n")
        for subStyle in subStyles {
            subStyle.write(to: &buffer)
            buffer.append("\n")
        }
        buffer.append("</Style>")
    }

    public func kmlString() -> String {
        var buffer = String()
        write(to: &buffer)
        return buffer
    }
}
