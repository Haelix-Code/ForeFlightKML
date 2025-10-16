import XCTest

@testable import ForeFlightKML

final class LabelStyleTests: XCTestCase {
    func testLabelStyleGeneratesKML() {
        let label = LabelStyle(color: .fromHex("FF0000"))
        let expected = """
            <LabelStyle>
            <color>ff0000ff</color>
            </LabelStyle>
            """
        XCTAssertEqual(label.kmlString(), expected)
    }

    func testStyleWithOnlyIcon() {
        let icon = IconStyle.predefined(type: .circle, color: .red)
        let kml = icon.kmlString()
        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertFalse(kml.contains("<LabelStyle>"))
    }

    func testStyleWithIconAndLabel() {
        let style = PointStyle(
            icon: .custom(type: .forbidden, color: .advisory), label: .init(color: .advisory))
        let kml = style.kmlString()
        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertTrue(kml.contains("<LabelStyle>"))
    }
}
