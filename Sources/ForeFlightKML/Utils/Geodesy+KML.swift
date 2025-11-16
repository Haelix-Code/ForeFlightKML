import GeodesySpherical

// KML uses 3D geographic coordinates: longitude, latitude and altitude, in that order.
// The longitude and latitude components are in decimal degrees
// as defined by the World Geodetic System of 1984 (WGS-84).
// The vertical component (altitude) is measured in meters from the WGS84 EGM96 Geoid vertical datum.

extension GeodesySpherical.Coordinate {
    public func kmlString() -> String {
        return "\(self.longitude),\(self.latitude)"
    }
}

/// 3D coordinate used only for KML string generation (longitude, latitude, optional altitude).
/// Internally used while producing `<coordinates>` lists.
internal struct Coordinate3D: Hashable {
    public let coordinate: Coordinate
    public let altitude: Double?

    public init(
        latitude: GeodesySpherical.Degrees, longitude: GeodesySpherical.Degrees,
        altitude: Double? = nil
    ) {
        self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
        self.altitude = altitude
    }

    public init(_ coordinate: Coordinate, altitude: Double? = nil) {
        self.coordinate = coordinate
        self.altitude = altitude
    }

    public var latitude: GeodesySpherical.Degrees { coordinate.latitude }
    public var longitude: GeodesySpherical.Degrees { coordinate.longitude }

    public func kmlString() -> String {
        if let altitude = self.altitude {
            return "\(self.longitude),\(self.latitude),\(altitude)"
        } else {
            return "\(self.longitude),\(self.latitude)"
        }
    }
}
