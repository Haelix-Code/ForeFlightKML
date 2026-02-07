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

    /// Write KML directly into a mutable string buffer, avoiding intermediate allocations.
    public func write(to buffer: inout String) {
        precondition(!coordinates.isEmpty, "\(Self.elementName) must have at least one coordinate")

        buffer.append("<\(Self.elementName)>\n")

        if let tessellate = tessellate {
            buffer.append("<tessellate>\(tessellate ? 1 : 0)</tessellate>\n")
        }

        if shouldEmitAltitudeMode(hasAltitude: altitude != nil) {
            buffer.append(altitudeModeTag())
            buffer.append("\n")
        }

        buffer.append("<coordinates>\n")
        for coord in coordinates {
            coord.writeKML(to: &buffer, altitude: altitude)
        }
        buffer.append("</coordinates>\n")
        buffer.append("</\(Self.elementName)>\n\n")
    }

    /// Generate KML string representation for coordinate-based geometries.
    /// This provides a standard implementation that handles coordinates, altitude, and tessellation.
    /// - Returns: Complete KML element string
    public func kmlString() -> String {
        var buffer = String()
        buffer.reserveCapacity(coordinates.count * 30 + 100)
        write(to: &buffer)
        return buffer
    }
}
