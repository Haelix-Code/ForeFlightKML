import Foundation

/// Style for point geometries (waypoints, markers, locations).
///
/// Point styles combine an icon with an optional text label.
/// Both elements are displayed together at the point location.
///
public struct PointStyle: KMLStyle {
    public let icon: IconStyle
    public let label: LabelStyle?
    private let styleId: String

    /// Create a new point style.
    /// - Parameters:
    ///   - icon: The icon appearance
    ///   - label: Optional text label style for the placemark name
    ///   - id: Optional unique identifier (auto-generated if not provided)
    public init(icon: IconStyle, label: LabelStyle? = nil, id: String? = nil) {
        self.icon = icon
        self.label = label
        self.styleId = id ?? "ps-\(UUID().uuidString)"
    }

    public func id() -> String {
        return styleId
    }

    public func kmlString() -> String {
        var components: [String] = []
        components.append("<Style id=\"\(styleId)\">")
        components.append(icon.kmlString())
        if let label = label {
            components.append(label.kmlString())
        }
        components.append("</Style>")
        return components.joined(separator: "\n")
    }
}
