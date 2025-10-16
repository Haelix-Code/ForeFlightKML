import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class SubStyleTests: XCTestCase {
    func testSimpleLineStyle() throws {
        var line = LineStyle(color: .warning)
        var kml = line.kmlString()

        XCTAssertTrue(
            kml.contains("<color>ff0000ff</color>"))
        XCTAssertFalse(kml.contains("<width>1.0</width>"))

        line = LineStyle(color: .caution)
        kml = line.kmlString()
        XCTAssertTrue(
            kml.contains("<color>ff0ad6ff</color>"))

        line = LineStyle(color: .advisory)
        kml = line.kmlString()
        XCTAssertTrue(
            kml.contains("<color>ff58d130</color>"))
    }

    func testSimpleCustomLineStyle() throws {
        let line = LineStyle(color: .warning, width: 1.0)
        let kml = line.kmlString()

        XCTAssertTrue(
            kml.contains("<color>ff0000ff</color>"))
        XCTAssertTrue(kml.contains("<width>1.0</width>"))
    }
}
