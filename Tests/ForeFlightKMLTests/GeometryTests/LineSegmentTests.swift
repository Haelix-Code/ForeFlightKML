import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class LineSegmentTests: XCTestCase {
    func testBuildSegment() throws {
        let builder = ForeFlightKMLBuilder(documentName: "My Test KML")
        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)

        let segmentElement = LineSegment.init(
            center: center, radius: 200, startAngle: 120.0, endAngle: 150.0)
        builder.addPlacemark(Placemark(name: "Pizza Wedge", geometry: segmentElement))

        let kml = builder.kmlString()

        XCTAssertTrue(kml.contains("<LineString>"), "Expected KML to contain the LineSTring name")
    }

    func testBuildSegmentAltitude() throws {
        let builder = ForeFlightKMLBuilder(documentName: "My Test KML")
        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)

        let segmentElementRed = LineSegment.init(
            center: center, radius: 200, startAngle: 90.0, endAngle: 150.0, altitude: 2500)
        let segmentElementBlue = LineSegment.init(
            center: center, radius: 200, startAngle: 330.0, endAngle: 30.0, altitude: 3000)

        builder.addPlacemark(
            Placemark(name: "Red Pizza Wedge", geometry: segmentElementRed))
        builder.addPlacemark(
            Placemark(
                name: "Blue Pizza Wedge", geometry: segmentElementBlue))

        let kml = builder.kmlString()

        XCTAssertTrue(
            kml.contains("<LineString>"), "Expected KML to contain the LineString element")
        XCTAssertTrue(
            kml.contains("-77.055967,38.870098,2500.0"),
            "Expected KML to contain the placemark name")
    }
}
