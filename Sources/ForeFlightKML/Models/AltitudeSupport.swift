/// Geometry types that support altitude specification at the geometry level.
/// Individual coordinates can have altitudes, but the altitude mode is defined here.
public protocol AltitudeSupport {
    /// How altitude values should be interpreted relative to the ground/sea level
    var altitudeMode: AltitudeMode? { get }
}

extension AltitudeSupport {
    func altitudeModeTag() -> String {
        guard let mode = altitudeMode else { return "" }
        return "<altitudeMode>\(mode.rawValue)</altitudeMode>"
    }

    func shouldEmitAltitudeMode(hasAltitude: Bool) -> Bool {
        return hasAltitude && altitudeMode != nil
    }
}

/// Supported Altitude Modes per KML 2.2 specification
/// See: https://developers.google.com/kml/documentation/kmlreference#altitudemode
public enum AltitudeMode: String, Equatable {
    case absolute
    case clampToGround
    case relativeToGround
    case clampToSeaFloor
    case relativeToSeaFloor
}
