import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class PolygonSegmentsTests: XCTestCase {
    func testBuildBasicSegments() throws {
        let builder = ForeFlightKMLBuilder(documentName: "My Test KML")

        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)

        let circle = PolygonSegment(center: center, radius: 500, startAngle: 45, endAngle: 135)
        let pm = Placemark(name: "Nice Segment", geometry: circle)
        builder.addPlacemark(pm)
        let kml = builder.kmlString()

        XCTAssertTrue(kml.contains("<Placemark>"), "Expected KML to contain a Placemark element")
        XCTAssertTrue(
            kml.contains(
                """
                <Polygon>
                <outerBoundaryIs>
                <LinearRing>
                <coordinates>
                """), "Expected KML to contain a Polygon element")
    }
}
