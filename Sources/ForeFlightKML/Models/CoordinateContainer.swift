import GeodesySpherical

/// Protocol for KML elements that contain coordinate arrays and support altitude/tessellation.
/// Used by LineString, LinearRing, and similar coordinate-based geometries.
internal protocol CoordinateContainer: KMLElement, AltitudeSupport {
    /// The array of coordinates that define this geometry
    var coordinates: [Coordinate] { get }
    /// Optional uniform altitude applied to all coordinates (in meters)
    var altitude: Double? { get }
    /// Whether to tessellate (follow ground contours) when rendering
    var tessellate: Bool? { get }
    /// The KML element name for this geometry type (e.g., "LineString", "LinearRing")
    static var elementName: String { get }
}

extension CoordinateContainer {
    /// Default tessellate behavior is to not even include the tag
    public var tessellate: Bool? { nil }

    /// Generate KML string representation for coordinate-based geometries.
    /// This provides a standard implementation that handles coordinates, altitude, and tessellation.
    /// - Returns: Complete KML element string
    public func kmlString() -> String {
        precondition(!coordinates.isEmpty, "\(Self.elementName) must have at least one coordinate")

        let coords3D = coordinates.map { Coordinate3D($0, altitude: altitude) }

        var kmlComponents: [String] = []

        kmlComponents.append("<\(Self.elementName)>")

        if let tessellate = tessellate {
            kmlComponents.append("<tessellate>\(tessellate ? 1 : 0)</tessellate>")
        }

        // Add altitude mode if altitude is specified
        if shouldEmitAltitudeMode(hasAltitude: altitude != nil) {
            kmlComponents.append(altitudeModeTag())
        }

        // Add coordinates
        kmlComponents.append("<coordinates>")
        for coord in coords3D {
            kmlComponents.append(coord.kmlString())
        }
        kmlComponents.append("</coordinates>")
        kmlComponents.append("</\(Self.elementName)>\n")

        return kmlComponents.joined(separator: "\n")
    }
}
