/// Defines the visual appearance of filled polygon areas in ForeFlight.
///
/// PolyStyle controls how the interior of polygons appears:
/// - Fill color (including transparency)
/// - Whether the polygon should be filled at all
///
/// When combined with LineStyle in the same Style object, you can create
/// polygons with both colored fills and colored outlines.
///
public struct PolyStyle: KMLSubStyle {
    var color: KMLColor
    var fill: Bool?

    /// Create a new polygon style.
    /// - Parameters:
    ///   - color: The fill color of the polygon
    ///   - fill: Whether to fill the polygon (optional, defaults to viewer behavior)
    public init(color: KMLColor, fill: Bool? = nil) {
        self.fill = fill
        self.color = color
    }

    public func kmlString() -> String {
        let lines: [String?] = [
            "<PolyStyle>",
            "<color>\(color.kmlHexString)</color>",
            fill.map { "<fill>\($0 ? 1 : 0)</fill>" },
            "</PolyStyle>",
        ]
        return lines.compactMap { $0 }.joined(separator: "\n")
    }
}
