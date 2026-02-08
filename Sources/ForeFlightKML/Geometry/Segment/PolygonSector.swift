import GeodesySpherical

public struct PolygonSector: KMLElement, AltitudeSupport {
    let polygon: Polygon

    public var altitudeMode: AltitudeMode? { polygon.altitudeMode }

    public init(
        center: Coordinate,
        radius: Double,
        startAngle: Double,
        endAngle: Double,
        numberOfPoints: Int = 100,
        altitude: Double? = nil,
        altitudeMode: AltitudeMode? = nil,
        tessellate: Bool? = nil
    ) {
        let coordinates = SectorGeometry.generateSectorPoints(
            center: center, radius: radius, startAngle: startAngle, endAngle: endAngle,
            numberOfPoints: numberOfPoints)

        let ring = LinearRing(coordinates: coordinates, altitude: altitude)
        self.polygon = Polygon(outer: ring, altitudeMode: altitudeMode, tessellate: tessellate)
    }

    public func write(to buffer: inout String) {
        polygon.write(to: &buffer)
    }

    public func write(to buffer: inout String, precision: Int) {
        polygon.write(to: &buffer, precision: precision)
    }

    public func kmlString() -> String {
        return polygon.kmlString()
    }
}
