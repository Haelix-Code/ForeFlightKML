import GeodesySpherical

/// A line string connecting multiple coordinates in order.
/// Used for routes, boundaries, or any connected line geometry.
public struct LineString: CoordinateContainer {
    public static let elementName = "LineString"
    public let coordinates: [Coordinate]
    public var altitude: Double?
    public var altitudeMode: AltitudeMode?
    public var tessellate: Bool?

    /// Create a new line string.
    /// - Parameters:
    ///   - coordinates: Points to connect in order (minimum 2 required)
    ///   - altitude: Optional uniform altitude for all points
    ///   - altitudeMode: How to interpret altitude
    ///   - tessellate: Whether to drape line on terrain
    public init(
        coordinates: [Coordinate],
        altitude: Double? = nil,
        altitudeMode: AltitudeMode? = nil,
        tessellate: Bool? = nil
    ) {
        self.coordinates = coordinates
        self.altitude = altitude
        self.tessellate = tessellate
        self.altitudeMode = altitudeMode
    }
}

/// Shared interface for "line-like" geometries: they expose coordinates and altitude/tessellate.
public protocol LineLike: KMLElement, AltitudeSupport {
    var coordinates: [Coordinate] { get }
    var altitude: Double? { get }
    var tessellate: Bool? { get }
}

extension LineLike {
    public func kmlString() -> String {
        let lineString = LineString(
            coordinates: coordinates, altitude: altitude, tessellate: tessellate)
        return lineString.kmlString()
    }
}
