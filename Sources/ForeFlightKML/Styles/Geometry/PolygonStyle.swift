import Foundation

/// Style for polygon geometries (areas, zones, regions).
///
/// Polygon styles combine an outline with an optional fill.
/// This allows you to create:
/// - Solid filled areas with colored borders
/// - Hollow areas with just outlines (no fill)
/// - Semi-transparent areas for overlays
///
public struct PolygonStyle: KMLStyle {
    public let outline: LineStyle
    public let fill: PolyStyle?
    private let styleId: String

    /// Create a new polygon style with full control.
    /// - Parameters:
    ///   - outline: The border line appearance
    ///   - fill: Optional fill appearance for the interior
    ///   - id: Optional unique identifier (auto-generated if not provided)
    public init(outline: LineStyle, fill: PolyStyle? = nil, id: String? = nil) {
        self.outline = outline
        self.fill = fill
        self.styleId = id ?? "poly-\(UUID().uuidString)"
    }

    /// Convenience initializer for filled polygons with direct colors.
    /// - Parameters:
    ///   - outlineColor: Border line color
    ///   - outlineWidth: Border line width in pixels (default: 2.0)
    ///   - fillColor: Interior fill color
    ///   - id: Optional unique identifier (auto-generated if not provided)
    public init(
        outlineColor: KMLColor,
        outlineWidth: Double = 2.0,
        fillColor: KMLColor,
        id: String? = nil
    ) {
        self.outline = LineStyle(color: outlineColor, width: outlineWidth)
        self.fill = PolyStyle(color: fillColor, fill: true)
        self.styleId = id ?? "poly-\(UUID().uuidString)"
    }

    /// Convenience initializer for outline-only polygons.
    /// - Parameters:
    ///   - outlineColor: Border line color
    ///   - outlineWidth: Border line width in pixels (default: 2.0)
    ///   - id: Optional unique identifier (auto-generated if not provided)
    public init(
        outlineColor: KMLColor,
        outlineWidth: Double = 2.0,
        id: String? = nil
    ) {
        self.outline = LineStyle(color: outlineColor, width: outlineWidth)
        self.fill = nil
        self.styleId = id ?? "poly-\(UUID().uuidString)"
    }

    public func id() -> String {
        return styleId
    }

    public func kmlString() -> String {
        var components: [String] = []
        components.append("<Style id=\"\(styleId)\">")
        components.append(outline.kmlString())
        if let fill = fill {
            components.append(fill.kmlString())
        }
        components.append("</Style>")
        return components.joined(separator: "\n")
    }
}
