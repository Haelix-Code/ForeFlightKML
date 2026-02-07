import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class AltitudeSupportTests: XCTestCase {

    struct DummyGeometry: AltitudeSupport {
        var altitude: Double?
        var altitudeMode: AltitudeMode?
    }

    func testAltitudeModeTagWhenNil() {
        let geo = DummyGeometry(altitude: nil, altitudeMode: nil)
        XCTAssertEqual(geo.altitudeModeTag(), "")
    }

    func testAltitudeModeTagWhenSet() {
        let geo = DummyGeometry(altitude: nil, altitudeMode: .absolute)
        XCTAssertEqual(geo.altitudeModeTag(), "<altitudeMode>absolute</altitudeMode>")
    }

    func testPointWithAltitudeNoMode() {
        let point = Point(Coordinate(latitude: 1, longitude: -1), altitude: 0)
        let kml = point.kmlString()
        XCTAssertTrue(kml.contains("<coordinates>-1.00000000,1.00000000,0.0</coordinates>"))
        XCTAssertFalse(kml.contains("<altitudeMode>"))
    }

    func testPointWithNoAltitude() {
        let point = Point(Coordinate(latitude: -1, longitude: 1))
        let kml = point.kmlString()
        XCTAssertTrue(kml.contains("1.00000000,-1.00000000"))
        XCTAssertFalse(kml.contains(",0</coordinates>"))
        XCTAssertFalse(kml.contains("<altitudeMode>"))
    }
}
