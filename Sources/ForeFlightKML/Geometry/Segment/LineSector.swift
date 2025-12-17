import GeodesySpherical

/// An arc or sector geometry (like a pie slice) defined by center, radius, and angular extents.
///
/// The sector starts from the center, extends to the radius at the start angle,
/// follows the arc to the end angle, then returns to center, creating a closed shape.
///
/// Angles are measured in degrees clockwise from North (0°).
///
public struct LineSector: KMLElement, LineLike {
    /// The coordinates that define this arc sector
    public var coordinates: [Coordinate]
    /// Optional altitude in meters applied to all coordinates
    public var altitude: Double?
    /// How altitude should be interpreted
    public var altitudeMode: AltitudeMode?
    /// Whether to tessellate (follow ground contours) when rendering
    public var tessellate: Bool?

    /// Create a new arc sector geometry.
    /// - Parameters:
    ///   - center: The center point of the arc
    ///   - radius: Radius in meters (must be positive)
    ///   - startAngle: Starting angle in degrees (0° = North, clockwise)
    ///   - endAngle: Ending angle in degrees (0° = North, clockwise)
    ///   - altitude: Optional altitude in meters applied to all points
    ///   - numberOfPoints: Number of points along the arc (default: 25)
    ///   - tessellate: Whether the line should follow ground contours
    public init(
        center: Coordinate,
        radius: Double,
        startAngle: Double,
        endAngle: Double,
        altitude: Double? = nil,
        altitudeMode: AltitudeMode? = nil,
        numberOfPoints: Int = 25,
        tessellate: Bool = false
    ) {
        self.altitude = altitude
        self.tessellate = tessellate
        self.altitudeMode = altitudeMode
        self.coordinates = SectorGeometry.generateSectorPoints(
            center: center, radius: radius, startAngle: startAngle, endAngle: endAngle,
            numberOfPoints: numberOfPoints)
    }

}
