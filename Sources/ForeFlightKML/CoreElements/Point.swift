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

    public func write(to buffer: inout String) {
        write(to: &buffer, precision: kDefaultCoordinatePrecision)
    }

    public func write(to buffer: inout String, precision: Int) {
        buffer.append("<Point>\n")
        buffer.append("<gx:drawOrder>1</gx:drawOrder>\n")

        if shouldEmitAltitudeMode(hasAltitude: altitude != nil) {
            buffer.append(altitudeModeTag())
            buffer.append("\n")
        }

        buffer.append("<coordinates>")
        buffer.append(formatCoordinate(coordinate.longitude, precision: precision))
        buffer.append(",")
        buffer.append(formatCoordinate(coordinate.latitude, precision: precision))
        if let alt = altitude {
            buffer.append(",")
            buffer.append(formatCoordinate(alt, precision: 1))
        }
        buffer.append("</coordinates>\n")
        buffer.append("</Point>\n")
    }

    public func kmlString() -> String {
        var buffer = String()
        write(to: &buffer)
        return buffer
    }
}
