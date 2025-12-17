import XCTest
import GeodesySpherical
@testable import ForeFlightKML

final class PointStylesTests: XCTestCase {

    func testPointStyleWithIconOnly() {
        let pointStyle = PointStyle(
            icon: .predefined(type: .circle, color: .red, scale: 1.5)
        )

        let kml = pointStyle.kmlString()
        XCTAssertTrue(kml.contains("<Style id="))
        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertFalse(kml.contains("<LabelStyle>"))
    }

    func testPointStyleWithIconAndLabel() {
        let pointStyle = PointStyle(
            icon: .predefined(type: .pushpin, color: .red),
            label: LabelStyle(color: .white)
        )

        let kml = pointStyle.kmlString()
        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertTrue(kml.contains("<LabelStyle>"))
        XCTAssertTrue(kml.contains("red-pushpin.png"))
    }

    func testPointStyleWithCustomIcon() {
        let pointStyle = PointStyle(
            icon: .custom(type: .triangle, color: .warning, scale: 2.0),
            label: LabelStyle(color: .black)
        )

        let kml = pointStyle.kmlString()
        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertTrue(kml.contains("<LabelStyle>"))
        XCTAssertTrue(kml.contains("triangle.png"))
        XCTAssertTrue(kml.contains("<scale>2.0</scale>"))
    }

    func testPointStyleGeneratesUniqueIds() {
        let style1 = PointStyle(icon: .predefined(type: .circle, color: .red))
        let style2 = PointStyle(icon: .predefined(type: .circle, color: .red))

        XCTAssertNotEqual(style1.id(), style2.id())
    }

    func test_pointStyle_requiresKMZ_followsIconStyle() {
        let s1 = PointStyle(icon: .transparentLocalPng(tint: .white))
        XCTAssertTrue(s1.requiresKMZ)

        let s2 = PointStyle(icon: .custom(type: .square, color: .white))
        XCTAssertFalse(s2.requiresKMZ)
    }

    func test_labelBadge_requiresKMZ_true() {
        let s = PointStyle.labelBadge(color: .warning)
        XCTAssertTrue(s.requiresKMZ)
    }

    func test_addLabel_emitsTransparentHref_andIconColor() {
        let builder = ForeFlightKMLBuilder(documentName: "Test")
        builder.addLabel("Badge", coordinate: Coordinate(latitude: 51.0, longitude: -1.0), color: .warning)

        let kml = builder.build()

        XCTAssertTrue(kml.contains("<href>1x1.png</href>"))
        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertTrue(kml.contains("<color>"), "Label badge must emit IconStyle color (drives ForeFlight badge)")
    }

    func test_labelBadge_doesNotEmitLabelStyle() {
        let style = PointStyle.labelBadge(color: .warning, id: "fixed")
        let xml = style.kmlString()

        XCTAssertFalse(xml.contains("<LabelStyle>"), "labelBadge should omit LabelStyle (ForeFlight ignores it)")
    }
}
