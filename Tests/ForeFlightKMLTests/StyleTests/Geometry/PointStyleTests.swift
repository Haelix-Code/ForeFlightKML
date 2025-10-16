import XCTest

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
}
