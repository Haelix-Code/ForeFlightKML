import GeodesySpherical
import Foundation
import XCTest

@testable import ForeFlightKML

final class ForeFlightKMLTests: XCTestCase {

    func testBuildBasicLine() throws {
        let builder = ForeFlightKMLBuilder(documentName: "My Test KML")

        let start = Coordinate(latitude: 33.29349602069717, longitude: -97.83722968666947)
        let end = Coordinate(latitude: 31.29050449094128, longitude: -97.828182763451)

        builder.addLine(name: "Nice Line", coordinates: [start, end])
        let kml = builder.kmlString()

        XCTAssertTrue(kml.contains("Placemark"), "Expected KML to contain a Placemark element")
        XCTAssertTrue(kml.contains("Nice Line"), "Expected KML to contain the name")
    }

    func testBuildBasicLineWithStyle() throws {
        let builder = ForeFlightKMLBuilder(documentName: "My Test KML")
        let start = Coordinate(latitude: 33.29349602069717, longitude: -97.83722968666947)
        let end = Coordinate(latitude: 31.29050449094128, longitude: -97.828182763451)

        builder.addLine(name: "Test Line", coordinates: [start, end], style: .init(color: .black))
        let kml = builder.kmlString()

        let data = Data(kml.utf8)
        let xmlDoc = try XMLDocument(data: data)
        guard let styleElement = try xmlDoc.nodes(forXPath: "//Style").first as? XMLElement,
            let styleId = styleElement.attribute(forName: "id")?.stringValue
        else {
            XCTFail("Style element or id attribute not found")
            return
        }

        guard let styleUrlElement = try xmlDoc.nodes(forXPath: "//styleUrl").first as? XMLElement
        else {
            XCTFail("<styleUrl> element not found")
            return
        }

        let styleUrlValue = styleUrlElement.stringValue?.trimmingCharacters(
            in: .whitespacesAndNewlines)

        XCTAssertEqual("#\(styleId)", styleUrlValue, "Style ID and styleUrl value do not match")

        XCTAssertTrue(kml.contains("<color>ff000000</color>"))
    }

    func testBuildBasicCircle() throws {
        let builder = ForeFlightKMLBuilder(documentName: "My Test KML")
        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)

        builder.addLineCircle(name: "500m circle", center: center, radiusMeters: 500)
        let kml = builder.kmlString()

        XCTAssertTrue(kml.contains("<Placemark>"), "Expected KML to contain a Placemark element")
        XCTAssertTrue(kml.contains("500m circle"), "Expected KML to contain the placemark name")
    }
}
