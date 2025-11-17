import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class LineStringTests: XCTestCase {
    func testKmlWithAltitudeAndTessellate() {
        let coords = [
            Coordinate(latitude: 2, longitude: 3),
            Coordinate(latitude: 4, longitude: 5)
        ]
        let line = LineString(
            coordinates: coords, altitude: 100.0, altitudeMode: .absolute, tessellate: true)
        let kml = line.kmlString()

        XCTAssertTrue(kml.contains("<LineString>"))
        XCTAssertTrue(kml.contains("<tessellate>1</tessellate>"))
        XCTAssertTrue(kml.contains("<altitudeMode>"))
        XCTAssertTrue(kml.contains("3.0,2.0,100.0"))
        XCTAssertTrue(kml.contains("5.0,4.0,100.0"))
    }

    func testLineLikeDelegatesToLineString() {
        struct TestLine: LineLike {
            var coordinates: [Coordinate]
            var altitude: Double?
            var altitudeMode: AltitudeMode?
            var tessellate: Bool?
        }

        let lineLike = TestLine(
            coordinates: [Coordinate(latitude: 1, longitude: 2)],
            altitude: 42,
            tessellate: true
        )

        let kml = lineLike.kmlString()
        XCTAssertTrue(kml.contains("<LineString>"))
        XCTAssertTrue(kml.contains("2.0,1.0,42.0"))
        XCTAssertTrue(kml.contains("<tessellate>1</tessellate>"))
    }
}
