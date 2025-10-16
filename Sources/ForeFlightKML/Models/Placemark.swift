import GeodesySpherical

/// Represents a Feature Placemark that combines geometry with styling and metadata.
///
/// Placemarks are the main building blocks of KML documents. Each placemark contains:
/// - A geometry (Point, Line, Polygon, etc.)
/// - Optional name that appears in ForeFlight
/// - Optional style that controls visual appearance
///
public struct Placemark {
    public private(set) var name: String?
    public private(set) var geometry: KMLElement
    public private(set) var styleUrl: String?
    public private(set) var style: KMLStyle?

    /// Create a new placemark with geometry and style.
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - geometry: The geographic shape (Point, Line, Polygon, etc.)
    ///   - style: Visual appearance style (optional)
    public init(name: String? = nil, geometry: KMLElement, style: KMLStyle? = nil) {
        self.name = name
        self.geometry = geometry
        self.styleUrl = style?.id()
        self.style = style
    }

    /// Create a placemark with a single sub-style (convenience method).
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - geometry: The geographic shape
    ///   - subStyle: A single style component (LineStyle, IconStyle, etc.)
    ///   - styleUrl: Optional custom style ID
    public init(
        name: String? = nil, geometry: KMLElement, subStyle: KMLSubStyle, styleUrl: String? = nil
    ) {
        let style: Style
        if let styleUrl = styleUrl {
            style = Style(subStyles: [subStyle], styleId: styleUrl)
        } else {
            style = Style(subStyles: [subStyle])
        }
        self.init(name: name, geometry: geometry, style: style)
    }

    public func kmlString() -> String {
        var kmlComponents: [String] = []

        kmlComponents.append("<Placemark>")
        if let name = name { kmlComponents.append("<name>\(escapeForKML(name))</name>") }
        if let su = styleUrl { kmlComponents.append("<styleUrl>#\(su)</styleUrl>") }
        kmlComponents.append(geometry.kmlString())
        kmlComponents.append("</Placemark>")

        return kmlComponents.joined(separator: "\n")
    }
}
