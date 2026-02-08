import Foundation
import GeodesySpherical

// KML uses 3D geographic coordinates: longitude, latitude and altitude, in that order.
// The longitude and latitude components are in decimal degrees
// as defined by the World Geodetic System of 1984 (WGS-84).
// The vertical component (altitude) is measured in meters from the WGS84 EGM96 Geoid vertical datum.

/// Default coordinate precision when none is specified.
internal let kDefaultCoordinatePrecision = 8

/// Format a coordinate value to the given precision, trimming trailing zeros
/// but always keeping at least one decimal place.
///
/// Examples (precision 8):
///   `formatCoordinate(2.0, precision: 8)` → `"2.0"`
///   `formatCoordinate(51.123, precision: 8)` → `"51.123"`
///   `formatCoordinate(-1.58156600, precision: 8)` → `"-1.581566"`
///
/// Examples (precision 4):
///   `formatCoordinate(51.12345678, precision: 4)` → `"51.1235"`
///   `formatCoordinate(2.0, precision: 4)` → `"2.0"`
///
internal func formatCoordinate(_ value: Double, precision: Int) -> String {
    let formatted = String(format: "%.\(precision)f", value)

    // Find the decimal point
    guard let dotIndex = formatted.firstIndex(of: ".") else {
        return formatted + ".0"
    }

    // Trim trailing zeros, but keep at least one digit after the decimal
    let minimumEnd = formatted.index(dotIndex, offsetBy: 2) // keeps "X.Y" at minimum
    var end = formatted.endIndex
    while end > minimumEnd && formatted[formatted.index(before: end)] == "0" {
        end = formatted.index(before: end)
    }

    return String(formatted[formatted.startIndex..<end])
}

extension GeodesySpherical.Coordinate {
    /// Format coordinate as KML `longitude,latitude` string with given precision.
    /// Trailing zeros are trimmed (e.g. `2.0` not `2.00000000`).
    public func kmlString(precision: Int = 8) -> String {
        let lon = formatCoordinate(self.longitude, precision: precision)
        let lat = formatCoordinate(self.latitude, precision: precision)
        return "\(lon),\(lat)"
    }

    /// Write coordinate in KML format directly into a buffer, with optional altitude.
    internal func writeKML(to buffer: inout String, altitude: Double? = nil, precision: Int = kDefaultCoordinatePrecision) {
        buffer.append(formatCoordinate(self.longitude, precision: precision))
        buffer.append(",")
        buffer.append(formatCoordinate(self.latitude, precision: precision))
        if let alt = altitude {
            buffer.append(",")
            buffer.append(formatCoordinate(alt, precision: 1))
        }
        buffer.append("\n")
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

    public func kmlString(precision: Int = kDefaultCoordinatePrecision) -> String {
        let lon = formatCoordinate(self.longitude, precision: precision)
        let lat = formatCoordinate(self.latitude, precision: precision)
        if let altitude = self.altitude {
            let alt = formatCoordinate(altitude, precision: 1)
            return "\(lon),\(lat),\(alt)"
        } else {
            return "\(lon),\(lat)"
        }
    }
}
