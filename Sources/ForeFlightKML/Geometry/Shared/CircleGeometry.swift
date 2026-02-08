import GeodesySpherical

internal enum CircleGeometry {

    private static let radiansToDegrees = 180.0 / Double.pi

    static func generateCirclePoints(
        center: Coordinate, radius: Double, numberOfPoints: Int
    ) -> [Coordinate] {
        var circlePoints: [Coordinate] = []
        circlePoints.reserveCapacity(numberOfPoints + 2)

        let angleStep = 360.0 / Double(numberOfPoints)
        for i in 0...numberOfPoints {
            let bearingDegrees = Double(i) * angleStep
            let endPoint = center.destination(with: radius, bearing: bearingDegrees)
            circlePoints.append(
                Coordinate(latitude: endPoint.latitude, longitude: endPoint.longitude))
        }

        if let first = circlePoints.first, let last = circlePoints.last,
            first.longitude != last.longitude || first.latitude != last.latitude {
            circlePoints.append(first)
        }

        return circlePoints
    }
}
