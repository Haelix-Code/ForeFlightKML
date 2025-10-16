import GeodesySpherical
import XCTest

@testable import ForeFlightKML

struct TestContainerWithTessellate: CoordinateContainer {
    static let elementName = "TestContainer"
    var coordinates: [Coordinate]
    var altitude: Double?
    var altitudeMode: AltitudeMode? = .absolute
    var tessellate: Bool?
}

struct TestContainerWithoutTessellate: CoordinateContainer {
    static let elementName = "TestContainer"
    var coordinates: [Coordinate]
    var altitude: Double?
    var altitudeMode: AltitudeMode? = .absolute
}

final class CoordinateContainerTests: XCTestCase {
    func testKmlWithoutTessellate() {
        let coords = [Coordinate(latitude: 0, longitude: 0)]
        let container = TestContainerWithoutTessellate(coordinates: coords, altitude: nil)
        let kml = container.kmlString()

        XCTAssertTrue(kml.contains("<TestContainer>"))
        XCTAssertFalse(kml.contains("<tessellate>"))
        XCTAssertTrue(kml.contains("0.0,0.0"))
    }

    func testKmlWithTessellateAndAltitude() {
        let coords = [
            Coordinate(latitude: 1, longitude: 2),
            Coordinate(latitude: 3, longitude: 4),
        ]
        let container = TestContainerWithTessellate(
            coordinates: coords,
            altitude: 50.0,
            tessellate: true
        )
        let kml = container.kmlString()

        XCTAssertTrue(kml.contains("<TestContainer>"))
        XCTAssertTrue(kml.contains("<tessellate>1</tessellate>"))
        XCTAssertTrue(kml.contains("<altitudeMode>absolute</altitudeMode>"))
        XCTAssertTrue(kml.contains("2.0,1.0,50.0"))
        XCTAssertTrue(kml.contains("4.0,3.0,50.0"))
    }
}
