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

    public func kmlString() -> String {
        var kmlComponents: [String] = []
        kmlComponents.append("<Polygon>")

        if let tessellate = tessellate {
            kmlComponents.append("<tessellate>\(tessellate ? 1 : 0)</tessellate>")
        }

        // Add altitude mode if any ring has altitude
        let allRings = [outer] + inner
        let hasAnyAltitude = allRings.contains { $0.altitude != nil }
        if shouldEmitAltitudeMode(hasAltitude: hasAnyAltitude) {
            kmlComponents.append(altitudeModeTag())
        }

        kmlComponents.append("<outerBoundaryIs>\n" + outer.kmlString() + "</outerBoundaryIs>")
        for ring in inner {
            kmlComponents.append("<innerBoundaryIs>\n" + ring.kmlString() + "</innerBoundaryIs>")
        }
        kmlComponents.append("</Polygon>")

        return kmlComponents.joined(separator: "\n")
    }
}
