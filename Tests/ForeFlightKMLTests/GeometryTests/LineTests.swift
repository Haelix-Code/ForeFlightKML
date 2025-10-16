import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class LineTests: XCTestCase {

    func testBuildBasicLine() throws {
        let builder = ForeFlightKMLBuilder(documentName: "My Test KML")

        let start = Coordinate(latitude: 33.29349602069717, longitude: -97.83722968666947)
        let end = Coordinate(latitude: 31.29050449094128, longitude: -97.828182763451)

        let line = Line(coordinates: [start, end])
        let pm = Placemark(name: "Nice Line", geometry: line)
        builder.addPlacemark(pm)
        let kml = builder.kmlString()

        XCTAssertTrue(kml.contains("Placemark"), "Expected KML to contain a Placemark element")
        XCTAssertTrue(kml.contains("Nice Line"), "Expected KML to contain the name")
    }

}
