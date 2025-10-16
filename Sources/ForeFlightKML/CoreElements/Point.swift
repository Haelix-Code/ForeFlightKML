import GeodesySpherical

/// A geographic point in 3D space that can be displayed as a marker in ForeFlight.
///
/// Points are typically used for waypoints or other specific locations.
/// When combined with an IconStyle, they appear as custom icons in ForeFlight.
///

public struct Point: KMLElement, AltitudeSupport {
    /// The geographic coordinate of this point
    var coordinate: Coordinate
    /// Optional altitude in meters above the reference datum
    public var altitude: Double?
    /// How the altitude should be interpreted relative to the ground/sea level
    public var altitudeMode: AltitudeMode?

    /// Create a new point geometry.
    /// - Parameters:
    ///   - coordinate: The geographic location of this point
    ///   - altitude: Optional altitude in meters (uses altitudeMode for interpretation)
    public init(_ coord: Coordinate, altitude: Double? = nil, altitudeMode: AltitudeMode? = nil) {
        self.coordinate = coord
        self.altitude = altitude
        self.altitudeMode = altitudeMode
    }

    public func kmlString() -> String {
        let coordinate3D = Coordinate3D(coordinate, altitude: altitude)
        var kmlComponents: [String] = []

        kmlComponents.append("<Point>")
        kmlComponents.append("<gx:drawOrder>1</gx:drawOrder>")

        // Only emit altitude mode if we have altitude values
        if shouldEmitAltitudeMode(hasAltitude: altitude != nil) {
            kmlComponents.append(altitudeModeTag())
        }

        kmlComponents.append("<coordinates>\(coordinate3D.kmlString())</coordinates>")
        kmlComponents.append("</Point>")

        return kmlComponents.joined(separator: "\n")
    }
}
