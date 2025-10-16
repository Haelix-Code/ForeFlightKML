import GeodesySpherical

/// A simple line connecting multiple coordinates in sequence.
///

public struct Line: KMLElement, LineLike {
    /// The coordinates that define this line, connected in order
    public var coordinates: [Coordinate]
    /// Optional altitude in meters applied to all coordinates
    public var altitude: Double?
    /// How altitude should be interpreted
    public var altitudeMode: AltitudeMode?
    /// Whether to tessellate (follow ground contours) when rendering
    public var tessellate: Bool?

    /// Create a new line geometry.
    /// - Parameters:
    ///   - coordinates: Points to connect in order (minimum 2 required)
    ///   - altitude: Optional altitude in meters applied to all points
    ///   - tessellate: Whether the line should follow ground contours
    public init(
        coordinates: [Coordinate], altitude: Double? = nil, altitudeMode: AltitudeMode? = nil,
        tessellate: Bool? = nil
    ) {
        self.coordinates = coordinates
        self.altitude = altitude
        self.tessellate = tessellate
        self.altitudeMode = altitudeMode
    }
}
