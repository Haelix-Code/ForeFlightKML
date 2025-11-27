import Foundation
import GeodesySpherical

/// A circular line geometry approximated with multiple line segments.
///
/// The circle is approximated using straight lines. More points create a smoother circle
/// but increase file size and processing time.
///
public struct LineCircle: KMLElement, LineLike {
    /// The coordinates that approximate the circle
    public var coordinates: [Coordinate]
    /// Optional altitude in meters applied to all coordinates
    public var altitude: Double?
    /// How altitude should be interpreted
    public var altitudeMode: AltitudeMode?
    /// Whether to tessellate (follow ground contours) when rendering
    public var tessellate: Bool?

    /// Create a new circular line geometry.
    /// - Parameters:
    ///   - center: The center point of the circle
    ///   - radius: Radius in meters (must be positive)
    ///   - numberOfPoints: Number of line segments to approximate the circle (default: 100)
    ///   - tessellate: Whether the line should follow ground contours
    public init(
        center: Coordinate,
        radius: Double,
        numberOfPoints: Int = 100,
        altitude: Double? = nil,
        altitudeMode: AltitudeMode? = nil,
        tessellate: Bool? = nil
    ) {
        self.tessellate = tessellate
        self.altitude = altitude
        self.altitudeMode = altitudeMode

        self.coordinates = CircleGeometry.generateCirclePoints(
            center: center, radius: radius, numberOfPoints: numberOfPoints)
    }

}
