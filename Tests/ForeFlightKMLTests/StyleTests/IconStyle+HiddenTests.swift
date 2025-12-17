import XCTest
@testable import ForeFlightKML
import GeodesySpherical

final class LabelOnlyTests: XCTestCase {

    func test_iconStyleTransparentLocalPng_emitsLocalHref() {
        let kml = IconStyle.transparentLocalPng().kmlString()

        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertTrue(kml.contains("<Icon>"))
        XCTAssertTrue(
            kml.contains("<href>1x1.png</href>"),
            "Label-only icon must reference bundled transparent PNG"
        )
        XCTAssertTrue(kml.contains("</IconStyle>"))
    }

    func test_pointStyleLabelOnly_emitsStyle() {
        let style = PointStyle.labelBadge(color: .white)
        let kml = style.kmlString()

        XCTAssertTrue(kml.contains("<Style id=\""), "PointStyle should emit a Style wrapper")
        XCTAssertTrue(kml.contains("<IconStyle>"), "Label-only style must include IconStyle (hidden icon)")
        XCTAssertTrue(kml.contains("<href>1x1.png</href>"))
        XCTAssertFalse(kml.contains("<LabelStyle>"), "For Label-only, FF ignores LabelStyle")
        XCTAssertTrue(kml.contains("</Style>"))
    }

    func test_builderAddLabel_emitsPlacemarkNameAndHiddenIconScale() throws {
        let builder = ForeFlightKMLBuilder()

        builder.addLabel("Label Warning", coordinate: .init(latitude: 51.2345, longitude: -1.2345), color: .warning)
        let kml = try builder.build()

        XCTAssertTrue(kml.contains("<Placemark>"))
        XCTAssertTrue(kml.contains("<Style id=\"ps-"), "PointStyle should generate ps- style id by default")
        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertFalse(kml.contains("<LabelStyle>"), "For Label-only, FF ignores LabelStyle")
        XCTAssertTrue(kml.contains("<href>1x1.png</href>"))
        XCTAssertTrue(kml.contains("<Point>"), "Label must still be attached to a Point geometry")
        XCTAssertTrue(kml.contains("<coordinates>"), "Point should emit coordinates")
    }
}
