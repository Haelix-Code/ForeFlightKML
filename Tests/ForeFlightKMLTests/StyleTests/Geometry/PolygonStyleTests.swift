import XCTest

@testable import ForeFlightKML

final class PolygonStylesTests: XCTestCase {
    func testPolygonStyleWithFill() {
        let polygonStyle = PolygonStyle(
            outline: LineStyle(color: .warning, width: 2.0),
            fill: PolyStyle(color: .warning.withAlpha(0.3), fill: true)
        )

        let kml = polygonStyle.kmlString()
        XCTAssertTrue(kml.contains("<Style id="))
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertTrue(kml.contains("<PolyStyle>"))
        XCTAssertTrue(kml.contains("<width>2.0</width>"))
    }

    func testPolygonStyleOutlineOnly() {
        let polygonStyle = PolygonStyle(
            outline: LineStyle(color: .advisory, width: 3.0)
        )

        let kml = polygonStyle.kmlString()
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertFalse(kml.contains("<PolyStyle>"))
    }

    func testPolygonStyleConvenienceInitWithFill() {
        let polygonStyle = PolygonStyle(
            outlineColor: .warning,
            outlineWidth: 4.0,
            fillColor: .caution
        )

        let kml = polygonStyle.kmlString()
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertTrue(kml.contains("<PolyStyle>"))
        XCTAssertTrue(kml.contains("<width>4.0</width>"))
    }

    func testPolygonStyleConvenienceInitOutlineOnly() {
        let polygonStyle = PolygonStyle(
            outlineColor: .advisory,
            outlineWidth: 2.0
        )

        let kml = polygonStyle.kmlString()
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertFalse(kml.contains("<PolyStyle>"))
    }

    func testPolygonStyleWithCustomId() {
        let polygonStyle = PolygonStyle(
            outlineColor: .black,
            fillColor: .white,
            id: "airspace-zone"
        )

        XCTAssertEqual(polygonStyle.id(), "airspace-zone")
        let kml = polygonStyle.kmlString()
        XCTAssertTrue(kml.contains("id=\"airspace-zone\""))
    }

    func testPolygonStyleGeneratesUniqueIds() {
        let style1 = PolygonStyle(outlineColor: .warning)
        let style2 = PolygonStyle(outlineColor: .warning)

        XCTAssertNotEqual(style1.id(), style2.id())
    }

}
