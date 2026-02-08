import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class LinearRingTests: XCTestCase {
    func testKmlWithAltitudeAndTessellate() {
        let points = [
            [-100.1097399038377, 31.57870338920791],
            [-100.1165273813259, 30.28600960074139],
            [-98.96485321080908, 30.49650491542987],
            [-98.95965359046227, 30.92214152160733],
            [-99.09548335615463, 31.45369338953584],
            [-100.1097399038377, 31.57870338920791]
        ]

        let coords = points.map { pair in
            Coordinate(latitude: pair[1], longitude: pair[0])
        }

        let ring = LinearRing(coordinates: coords, altitude: 0.0)
        let kml = ring.kmlString()

        XCTAssertTrue(
            kml.contains(
                """
                <LinearRing>
                <coordinates>
                -100.1097399,31.57870339,0.0
                -100.11652738,30.2860096,0.0
                -98.96485321,30.49650492,0.0
                -98.95965359,30.92214152,0.0
                -99.09548336,31.45369339,0.0
                -100.1097399,31.57870339,0.0
                </coordinates>
                </LinearRing>
                """))
    }
}
