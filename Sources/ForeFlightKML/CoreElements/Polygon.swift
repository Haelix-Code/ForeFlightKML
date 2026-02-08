/// A polygon defined by an outer boundary and optional inner boundaries (holes).
///
///
/// The outer boundary must form a closed ring (first and last coordinates should match).
/// Inner boundaries create holes within the polygon.
///
public struct Polygon: KMLElement, AltitudeSupport {
    /// The outer boundary of the polygon (must be a closed ring)
    public let outer: LinearRing
    /// Optional inner boundaries that create holes in the polygon
    public let inner: [LinearRing]
    var tessellate: Bool?
    /// How altitudes should be interpreted
    public var altitudeMode: AltitudeMode?

    public init(
        outer: LinearRing,
        inner: [LinearRing] = [],
        altitudeMode: AltitudeMode? = nil,
        tessellate: Bool? = nil
    ) {
        self.outer = outer
        self.inner = inner
        self.tessellate = tessellate
        self.altitudeMode = altitudeMode
    }

    public func write(to buffer: inout String) {
        write(to: &buffer, precision: kDefaultCoordinatePrecision)
    }

    public func write(to buffer: inout String, precision: Int) {
        buffer.append("<Polygon>\n")

        if let tessellate = tessellate {
            buffer.append("<tessellate>\(tessellate ? 1 : 0)</tessellate>\n")
        }

        let allRings = [outer] + inner
        let hasAnyAltitude = allRings.contains { $0.altitude != nil }
        if shouldEmitAltitudeMode(hasAltitude: hasAnyAltitude) {
            buffer.append(altitudeModeTag())
            buffer.append("\n")
        }

        buffer.append("<outerBoundaryIs>\n")
        outer.write(to: &buffer, precision: precision)
        buffer.append("</outerBoundaryIs>\n")
        for ring in inner {
            buffer.append("<innerBoundaryIs>\n")
            ring.write(to: &buffer, precision: precision)
            buffer.append("</innerBoundaryIs>\n")
        }
        buffer.append("</Polygon>\n")
    }

    public func kmlString() -> String {
        var buffer = String()
        write(to: &buffer)
        return buffer
    }
}
