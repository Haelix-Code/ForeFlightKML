import GeodesySpherical

/// Defines a closed line string, typically the outer boundary of a Polygon. Optionally, a LinearRing can also be used as the inner boundary of a Polygon to create holes in the Polygon. A Polygon can contain multiple <LinearRing> elements used as inner boundaries.
/// Note: LinearRing does NOT support altitudeMode - that is specified at the Polygon level.
/// However, individual coordinates can still have altitude values.
public struct LinearRing: CoordinateContainer {
    public static let elementName = "LinearRing"
    public let coordinates: [Coordinate]
    public var altitude: Double?
    /// LinearRing doesn't define altitude mode (handled by parent Polygon)
    public var altitudeMode: AltitudeMode? { nil }
    public var tessellate: Bool?

    /// Create a new linear ring.
    /// - Parameters:
    ///   - coordinates: Array of coordinates forming the ring
    ///   - altitude: Optional uniform altitude for all coordinates
    /// - Note: The ring will be automatically closed if the first and last coordinates don't match
    public init(coordinates: [Coordinate], altitude: Double? = nil) {
        self.altitude = altitude

        // Auto-close the ring if needed
        if let first = coordinates.first, let last = coordinates.last,
            first.latitude != last.latitude || first.longitude != last.longitude {
            self.coordinates = coordinates + [first]
        } else {
            self.coordinates = coordinates
        }
    }

}
