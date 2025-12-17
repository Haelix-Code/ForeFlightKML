import Foundation
import GeodesySpherical

extension ForeFlightKMLBuilder {

    /// Add a point placemark with style.
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - coordinate: Geographic coordinate
    ///   - altitude: Altitude in meters (optional)
    ///   - style: Point style defining icon and optional label (optional)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addPoint(
        name: String?,
        coordinate: Coordinate,
        altitude: Double? = nil,
        style: PointStyle? = nil
    ) -> Self {
        let geometry = Point(coordinate, altitude: altitude)
        let placemark = Placemark(name: name, geometry: geometry, style: style)
        return addPlacemark(placemark)
    }

    /// Add a point placemark using latitude/longitude values.
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - latitude: Latitude in decimal degrees
    ///   - longitude: Longitude in decimal degrees
    ///   - altitude: Altitude in meters (optional)
    ///   - style: Point style defining icon and optional label (optional)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addPoint(
        name: String? = nil,
        latitude: Double,
        longitude: Double,
        altitude: Double? = nil,
        style: PointStyle? = nil
    ) -> Self {
        let coordinate = Coordinate(latitude: latitude, longitude: longitude)
        return addPoint(name: name, coordinate: coordinate, altitude: altitude, style: style)
    }

    /// Add a line placemark connecting multiple coordinates.
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - coordinates: Array of coordinates to connect
    ///   - altitude: Altitude in meters applied to all coordinates (optional)
    ///   - tessellate: Whether to follow ground contours (default: false)
    ///   - style: Path style defining line appearance (optional)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addLine(
        name: String?,
        coordinates: [Coordinate],
        altitude: Double? = nil,
        tessellate: Bool? = nil,
        style: PathStyle? = nil
    ) -> Self {
        let lineGeometry = LineString(
            coordinates: coordinates, altitude: altitude, tessellate: tessellate)
        let placemark = Placemark(name: name, geometry: lineGeometry, style: style)
        return addPlacemark(placemark)
    }

    /// Add a circular line (approximated by line segments).
    /// Perfect for depicting ranges, patterns, or restricted areas.
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - center: Center point of the circle
    ///   - radiusMeters: Radius in meters
    ///   - numberOfPoints: Number of line segments to approximate the circle (default: 64)
    ///   - altitude: Altitude in meters (optional)
    ///   - tessellate: Whether to follow ground contours (default: false)
    ///   - style: Path style defining line appearance (optional)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addLineCircle(
        name: String?,
        center: Coordinate,
        radiusMeters: Double,
        numberOfPoints: Int = 64,
        altitude: Double? = nil,
        tessellate: Bool? = nil,
        style: PathStyle? = nil
    ) -> Self {
        let circle = LineCircle(
            center: center,
            radius: radiusMeters,
            numberOfPoints: numberOfPoints,
            altitude: altitude,
            tessellate: tessellate
        )

        let placemark = Placemark(name: name, geometry: circle, style: style)
        return addPlacemark(placemark)
    }

    /// Add an arc sector line geometry.
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - center: Center point of the arc
    ///   - radiusMeters: Radius in meters
    ///   - startAngle: Starting angle in degrees (0° = North, clockwise)
    ///   - endAngle: Ending angle in degrees (0° = North, clockwise)
    ///   - numberOfPoints: Number of points along the arc (default: 25)
    ///   - altitude: Altitude in meters (optional)
    ///   - tessellate: Whether to follow ground contours (default: false)
    ///   - style: Path style defining line appearance (optional)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addLineSector(
        name: String? = nil,
        center: Coordinate,
        radiusMeters: Double,
        startAngle: Double,
        endAngle: Double,
        numberOfPoints: Int = 25,
        altitude: Double? = nil,
        tessellate: Bool = false,
        style: PathStyle? = nil
    ) -> Self {
        precondition(radiusMeters > 0, "Radius must be positive")
        precondition(numberOfPoints >= 3, "Need at least 3 segments for an arc")

        let sector = LineSector(
            center: center,
            radius: radiusMeters,
            startAngle: startAngle,
            endAngle: endAngle,
            altitude: altitude,
            numberOfPoints: numberOfPoints,
            tessellate: tessellate
        )

        let placemark = Placemark(name: name, geometry: sector, style: style)
        return addPlacemark(placemark)
    }

    /// Add a polygon with outer boundary and optional holes.
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - outerRing: Coordinates defining the outer boundary
    ///   - innerRings: Optional inner boundaries (holes in the polygon)
    ///   - altitude: Altitude in meters applied to all coordinates (optional)
    ///   - tessellate: Whether to follow ground contours (default: false)
    ///   - style: Polygon style defining outline and optional fill
    /// - Returns: Self for method chaining (optional)
    @discardableResult
    public func addPolygon(
        name: String?,
        outerRing: [Coordinate],
        innerRings: [[Coordinate]] = [],
        altitude: Double? = nil,
        tessellate: Bool? = nil,
        style: PolygonStyle? = nil
    ) -> Self {
        precondition(outerRing.count >= 3, "Polygon outer ring must have at least 3 coordinates")
        let outer = LinearRing(coordinates: outerRing, altitude: altitude)
        let inner = innerRings.map { LinearRing(coordinates: $0, altitude: altitude) }

        let polygon = Polygon(
            outer: outer,
            inner: inner,
            tessellate: tessellate
        )

        let placemark = Placemark(name: name, geometry: polygon, style: style)
        return addPlacemark(placemark)
    }

    /// Add a filled circle polygon.
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - center: Center point of the circle
    ///   - radiusMeters: Radius in meters
    ///   - numberOfPoints: Number of points along the arc (default: 64)
    ///   - altitude: Altitude in meters (optional)
    ///   - tessellate: Whether to follow ground contours (default: false)
    ///   - style: Polygon style defining outline and optional fill (optional)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addPolygonCircle(
        name: String? = nil,
        center: Coordinate,
        radiusMeters: Double,
        numberOfPoints: Int = 64,
        altitude: Double? = nil,
        tessellate: Bool = false,
        style: PolygonStyle? = nil
    ) -> Self {
        precondition(radiusMeters > 0, "Radius must be positive")
        precondition(numberOfPoints >= 3, "Need at least 3 segments for a circle")

        let circle = PolygonCircle(
            center: center,
            radius: radiusMeters,
            numberOfPoints: numberOfPoints,
            altitude: altitude,
            tessellate: tessellate
        )

        let placemark = Placemark(name: name, geometry: circle, style: style)
        return addPlacemark(placemark)
    }

    /// Add a filled sector polygon (pie slice).
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - center: Center point of the arc
    ///   - radiusMeters: Radius in meters
    ///   - startAngle: Starting angle in degrees (0° = North, clockwise)
    ///   - endAngle: Ending angle in degrees (0° = North, clockwise)
    ///   - numberOfPoints: Number of points along the arc (default: 64)
    ///   - altitude: Altitude in meters (optional)
    ///   - tessellate: Whether to follow ground contours (default: false)
    ///   - style: Polygon style defining outline and optional fill (optional)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addPolygonSector(
        name: String? = nil,
        center: Coordinate,
        radiusMeters: Double,
        startAngle: Double,
        endAngle: Double,
        numberOfPoints: Int = 64,
        altitude: Double? = nil,
        tessellate: Bool = false,
        style: PolygonStyle? = nil
    ) -> Self {
        precondition(radiusMeters > 0, "Radius must be positive")
        precondition(numberOfPoints >= 3, "Need at least 3 segments for a segment")

        let sector = PolygonSector(
            center: center,
            radius: radiusMeters,
            startAngle: startAngle,
            endAngle: endAngle,
            numberOfPoints: numberOfPoints,
            altitude: altitude,
            tessellate: tessellate
        )

        let placemark = Placemark(name: name, geometry: sector, style: style)
        return addPlacemark(placemark)
    }

    /// Add a filled annular (ring) sector polygon.
    /// This creates a sector between two radii, excluding the inner circle area.
    /// - Parameters:
    ///   - name: Display name in ForeFlight (optional)
    ///   - center: Center point of the sector
    ///   - innerRadius: Inner radius in meters (the "hole" size)
    ///   - outerRadius: Outer radius in meters
    ///   - startAngle: Starting angle in degrees (0° = North, clockwise)
    ///   - endAngle: Ending angle in degrees (0° = North, clockwise)
    ///   - numberOfPoints: Number of points for each arc (default: 64)
    ///   - altitude: Altitude in meters (optional)
    ///   - tessellate: Whether to follow ground contours (default: false)
    ///   - style: Polygon style defining outline and optional fill (optional)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addPolygonAnnularSector(
        name: String? = nil,
        center: Coordinate,
        innerRadius: Double,
        outerRadius: Double,
        startAngle: Double,
        endAngle: Double,
        numberOfPoints: Int = 64,
        altitude: Double? = nil,
        tessellate: Bool = false,
        style: PolygonStyle? = nil
    ) -> Self {
        precondition(innerRadius > 0, "Inner radius must be positive")
        precondition(outerRadius > innerRadius, "Outer radius must be greater than inner radius")
        precondition(numberOfPoints >= 3, "Need at least 3 segments for an annular segment")

        let sector = PolygonAnnularSector(
            center: center,
            innerRadius: innerRadius,
            outerRadius: outerRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            numberOfPoints: numberOfPoints,
            altitude: altitude,
            tessellate: tessellate
        )

        let placemark = Placemark(name: name, geometry: sector, style: style)
        return addPlacemark(placemark)
    }

    /// Add a text-only label placemark at a coordinate.
    /// This uses a transparent 1×1 icon to enable ForeFlight’s “badge” rendering, with the badge color driven by `IconStyle.color`.
    /// - Important: Because this relies on a local icon asset, the output **must be exported as KMZ** (not plain KML) for the label to render correctly.
    /// - Parameters:
    ///   - text: Label text displayed in ForeFlight
    ///   - coordinate: Geographic coordinate
    ///   - altitude: Altitude in meters (optional)
    ///   - color: Badge/background color for the label (default: white)
    /// - Returns: Self for method chaining
    @discardableResult
    public func addLabel(
        _ text: String,
        coordinate: Coordinate,
        altitude: Double? = nil,
        color: KMLColor = .white
    ) -> Self {
        addPoint(
            name: text,
            coordinate: coordinate,
            altitude: altitude,
            style: .labelBadge(color: color)
        )
    }

}
