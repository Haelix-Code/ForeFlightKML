import Foundation
import GeodesySpherical

internal enum SegmentGeometry {
    static func generateSegmentPoints(
        center: Coordinate, radius: Double, startAngle: Double, endAngle: Double,
        numberOfPoints: Int
    ) -> [Coordinate] {
        var segmentPoints: [Coordinate] = []
        segmentPoints.append(center)

        let start = startAngle.truncatingRemainder(dividingBy: 360)
        let end = endAngle.truncatingRemainder(dividingBy: 360)

        let angleSpan: Double
        if end >= start {
            angleSpan = end - start
        } else {
            angleSpan = (360 - start) + end
        }

        for i in 0...numberOfPoints {
            let fraction = Double(i) / Double(numberOfPoints)
            let currentAngle = (start + fraction * angleSpan)

            let endPoint = center.destination(with: radius, bearing: currentAngle)

            segmentPoints.append(endPoint)
        }

        segmentPoints.append(center)
        return segmentPoints
    }

    // swiftlint:disable:next function_parameter_count
    static func generateAnnularSegmentPoints(
        center: Coordinate,
        innerRadius: Double,
        outerRadius: Double,
        startAngle: Double,
        endAngle: Double,
        numberOfPoints: Int
    ) -> [Coordinate] {
        precondition(innerRadius > 0, "Inner radius must be positive")
        precondition(outerRadius > innerRadius, "Outer radius must be greater than inner radius")

        var points: [Coordinate] = []

        let start = startAngle.truncatingRemainder(dividingBy: 360)
        let end = endAngle.truncatingRemainder(dividingBy: 360)

        let angleSpan: Double
        if end >= start {
            angleSpan = end - start
        } else {
            angleSpan = (360 - start) + end
        }

        for i in 0...numberOfPoints {
            let fraction = Double(i) / Double(numberOfPoints)
            let currentAngle = start + fraction * angleSpan
            let point = center.destination(with: outerRadius, bearing: currentAngle)
            points.append(point)
        }

        for i in 0...numberOfPoints {
            let fraction = Double(i) / Double(numberOfPoints)
            let currentAngle = end - fraction * angleSpan
            let point = center.destination(with: innerRadius, bearing: currentAngle)
            points.append(point)
        }

        if let first = points.first {
            points.append(first)
        }

        return points
    }
}
