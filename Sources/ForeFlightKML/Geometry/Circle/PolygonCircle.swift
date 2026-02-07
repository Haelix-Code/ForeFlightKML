import GeodesySpherical

/// A circular polygon geometry approximated with multiple line segments.
///
/// The circle is approximated using straight lines. More points create a smoother circle
/// but increase file size and processing time.
/// Use with PolyStyle to fill.
///
public struct PolygonCircle: KMLElement, AltitudeSupport {
    let polygon: Polygon

    public var altitudeMode: AltitudeMode? { polygon.altitudeMode }

    public init(
        center: Coordinate,
        radius: Double,
        numberOfPoints: Int = 100,
        altitude: Double? = nil,
        altitudeMode: AltitudeMode? = nil,
        tessellate: Bool? = nil
    ) {
        let coordinates = CircleGeometry.generateCirclePoints(
            center: center, radius: radius, numberOfPoints: numberOfPoints)

        let ring = LinearRing(coordinates: coordinates, altitude: altitude)
        self.polygon = Polygon(outer: ring, altitudeMode: altitudeMode, tessellate: tessellate)
    }

    public func write(to buffer: inout String) {
        polygon.write(to: &buffer)
    }

    public func kmlString() -> String {
        return polygon.kmlString()
    }
}
