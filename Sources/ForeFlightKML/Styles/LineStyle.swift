/// Defines the visual appearance of line geometries in ForeFlight.
///
/// LineStyle controls how lines, circles, arcs, and polygon outlines appear:
/// - Line color
/// - Line width in pixels
///
/// This style applies to:
/// - Line and LineString geometries
/// - LineCircle and LineSector geometries
/// - Polygon outline borders
/// - Any other line-based geometry
///
public struct LineStyle: KMLSubStyle {
    var width: Double?
    var color: KMLColor

    public init(color: KMLColor, width: Double? = nil) {
        self.width = width
        self.color = color
    }

    public func kmlString() -> String {
        let lines: [String?] = [
            "<LineStyle>",
            "<color>\(color.kmlHexString)</color>",
            width.map { "<width>\($0)</width>" },
            "</LineStyle>"
        ]
        return lines.compactMap { $0 }.joined(separator: "\n")
    }
}
