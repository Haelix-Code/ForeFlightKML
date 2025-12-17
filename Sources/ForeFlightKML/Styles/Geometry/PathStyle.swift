import Foundation

/// Style for line-based geometries (routes, boundaries, circles).
///
/// Path styles define how lines are drawn. They apply to:
/// - Line and LineString geometries
/// - LineCircle and LineSector geometries
///
public struct PathStyle: KMLStyle {
    public let stroke: LineStyle
    private let styleId: String

    /// Create a new path style.
    /// - Parameters:
    ///   - stroke: The line appearance (color and width)
    ///   - id: Optional unique identifier (auto-generated if not provided)
    public init(stroke: LineStyle, id: String? = nil) {
        self.stroke = stroke
        self.styleId = id ?? "ls-\(UUID().uuidString)"
    }

    /// Convenience initializer with direct color and width.
    /// - Parameters:
    ///   - color: Line color
    ///   - width: Line width in pixels (default: 2.0)
    ///   - id: Optional unique identifier (auto-generated if not provided)
    public init(color: KMLColor, width: Double = 2.0, id: String? = nil) {
        self.stroke = LineStyle(color: color, width: width)
        self.styleId = id ?? "ls-\(UUID().uuidString)"
    }

    public func id() -> String {
        return styleId
    }

    public func kmlString() -> String {
        var components: [String] = []
        components.append("<Style id=\"\(styleId)\">")
        components.append(stroke.kmlString())
        components.append("</Style>")
        return components.joined(separator: "\n")
    }
}
