import GeodesySpherical

public struct PolygonAnnularSegment: KMLElement, AltitudeSupport {
    let polygon: Polygon
    
    public var altitudeMode: AltitudeMode? { polygon.altitudeMode }
    public init(
        center: Coordinate,
        innerRadius: Double,
        outerRadius: Double,
        startAngle: Double,
        endAngle: Double,
        numberOfPoints: Int = 100,
        altitude: Double? = nil,
        altitudeMode: AltitudeMode? = nil,
        tessellate: Bool? = nil
    ) {
        let coordinates = SegmentGeometry.generateAnnularSegmentPoints(
            center: center,
            innerRadius: innerRadius,
            outerRadius: outerRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            numberOfPoints: numberOfPoints
        )
        
        let ring = LinearRing(coordinates: coordinates, altitude: altitude)
        self.polygon = Polygon(outer: ring, altitudeMode: altitudeMode, tessellate: tessellate)
    }
    
    public func kmlString() -> String {
        return polygon.kmlString()
    }
}
