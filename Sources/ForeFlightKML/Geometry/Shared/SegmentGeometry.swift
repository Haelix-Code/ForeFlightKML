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
}
