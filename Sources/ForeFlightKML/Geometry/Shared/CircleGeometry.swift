import Foundation
import GeodesySpherical

internal enum CircleGeometry {
    static func generateCirclePoints(
        center: Coordinate, radius: Double, numberOfPoints: Int
    ) -> [Coordinate] {
        var circlePoints: [Coordinate] = []
        for i in 0...numberOfPoints {
            let bearingRadians = Double(i) * (2.0 * Double.pi) / Double(numberOfPoints)
            let bearingDegrees = Measurement(value: bearingRadians, unit: UnitAngle.radians)
                .converted(to: .degrees).value
            let endPoint = center.destination(with: radius, bearing: bearingDegrees)
            circlePoints.append(
                Coordinate(latitude: endPoint.latitude, longitude: endPoint.longitude))
        }

        if let first = circlePoints.first, let last = circlePoints.last,
            first.longitude != last.longitude || first.latitude != last.latitude
        {
            circlePoints.append(first)
        }

        return circlePoints
    }
}
