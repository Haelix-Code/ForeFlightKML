import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class LineCircleTests: XCTestCase {
    func testBuildBasicCircle() throws {
        let builder = ForeFlightKMLBuilder(documentName: "My Test KML")

        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)

        let circle = LineCircle(center: center, radius: 500)
        let pm = Placemark(name: "500m circle", geometry: circle)
        builder.addPlacemark(pm)
        let kml = builder.kmlString()

        XCTAssertTrue(kml.contains("<Placemark>"), "Expected KML to contain a Placemark element")
        XCTAssertTrue(kml.contains("500m circle"), "Expected KML to contain the placemark name")
    }
}
