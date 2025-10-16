import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class PointTests: XCTestCase {
    func testKmlWithoutAltitude() {
        let position = Coordinate(latitude: 38.898311, longitude: -77.036572)
        let point = Point(position)
        let kml = point.kmlString()

        XCTAssertTrue(kml.contains("<Point>"))
        XCTAssertTrue(kml.contains("<coordinates>-77.036572,38.898311</coordinates>"))
        XCTAssertFalse(kml.contains("<altitudeMode>"))
    }

    func testPointWithoutAltitudeStructure() throws {
        let position = Coordinate(latitude: 38.898311, longitude: -77.036572)
        let point = Point(position)
        let kml = point.kmlString()

        let xml = try XMLTestHelper.parseKMLFragment(kml)

        try XMLTestHelper.validateStructure(
            xml,
            expectedElements: [
                "Point", "gx:drawOrder", "coordinates",
            ])

        let drawOrder = try XMLTestHelper.getTextContent(elementName: "gx:drawOrder", from: xml)
        XCTAssertEqual(drawOrder, "1")

        let coordinates = try XMLTestHelper.getTextContent(elementName: "coordinates", from: xml)
        XCTAssertEqual(coordinates, "-77.036572,38.898311")

        let altitudeModeElements = try XMLTestHelper.extractElements(
            named: "altitudeMode", from: xml)
        XCTAssertTrue(
            altitudeModeElements.isEmpty, "altitudeMode should not be present without altitude")
    }

    func testKmlWithAltitude() {
        let position = Coordinate(latitude: 38.898311, longitude: -77.036572)
        let point = Point(position, altitude: 17.88, altitudeMode: .absolute)
        let kml = point.kmlString()

        XCTAssertTrue(kml.contains("<Point>"))
        XCTAssertTrue(kml.contains("<coordinates>-77.036572,38.898311,17.88</coordinates>"))
        XCTAssertTrue(kml.contains("<altitudeMode>"))
    }

    func testPointWithAltitudeUsingXML() throws {
        let position = Coordinate(latitude: 38.898311, longitude: -77.036572)
        let point = Point(position, altitude: 17.88, altitudeMode: .absolute)
        let kml = point.kmlString()

        let xml = try XMLTestHelper.parseKMLFragment(kml)

        try XMLTestHelper.validateStructure(
            xml,
            expectedElements: [
                "Point", "drawOrder", "altitudeMode", "coordinates",
            ])

        let altitudeMode = try XMLTestHelper.getTextContent(elementName: "altitudeMode", from: xml)
        XCTAssertEqual(altitudeMode, "absolute")

        let coordinates = try XMLTestHelper.getTextContent(elementName: "coordinates", from: xml)
        XCTAssertEqual(coordinates, "-77.036572,38.898311,17.88")
    }
}
