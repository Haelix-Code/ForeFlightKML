import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class GeometryStylesTests: XCTestCase {
    func testPointStyleWithBuilder() {
        let builder = ForeFlightKMLBuilder(documentName: "Test")

        builder.addPoint(
            name: "Airport",
            coordinate: Coordinate(latitude: 51.5, longitude: -0.1),
            style: PointStyle(
                icon: .predefined(type: .circle, color: .blue),
                label: LabelStyle(color: .white)
            )
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<Placemark>"))
        XCTAssertTrue(kml.contains("<name>Airport</name>"))
        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertTrue(kml.contains("<LabelStyle>"))
    }

    func testPathStyleWithBuilder() {
        let builder = ForeFlightKMLBuilder(documentName: "Test")
        let start = Coordinate(latitude: 51.5, longitude: -0.1)
        let end = Coordinate(latitude: 52.0, longitude: -0.2)

        builder.addLine(
            name: "Route",
            coordinates: [start, end],
            style: PathStyle(color: .warning, width: 3.0)
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<Placemark>"))
        XCTAssertTrue(kml.contains("<name>Route</name>"))
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertTrue(kml.contains("<width>3.0</width>"))
    }

    func testPolygonStyleWithBuilder() {
        let builder = ForeFlightKMLBuilder(documentName: "Test")
        let coords = [
            Coordinate(latitude: 51.5, longitude: -0.1),
            Coordinate(latitude: 51.6, longitude: -0.1),
            Coordinate(latitude: 51.6, longitude: -0.2),
            Coordinate(latitude: 51.5, longitude: -0.2),
        ]

        builder.addPolygon(
            name: "Airspace",
            outerRing: coords,
            style: PolygonStyle(
                outlineColor: .warning,
                outlineWidth: 2.0,
                fillColor: .warning.withAlpha(0.3)
            )
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<Placemark>"))
        XCTAssertTrue(kml.contains("<name>Airspace</name>"))
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertTrue(kml.contains("<PolyStyle>"))
    }
}
