import XCTest

@testable import ForeFlightKML

final class IconStyleTests: XCTestCase {
    func testSimplePredefinedColorShapeIcon() throws {
        let icon = IconStyle.predefined(type: .circle, color: .red)
        let kml = icon.kmlString()

        XCTAssertTrue(
            kml.contains("<href>http://maps.google.com/mapfiles/kml/paddle/red-circle.png</href>"),
            "Expected KML to contain href to red-circle.png")
    }

    func testSimpleCustomColorShapeIcon() throws {
        let icon = IconStyle.custom(type: .opendiamond, color: .black)
        let kml = icon.kmlString()

        XCTAssertTrue(
            kml.contains(
                "<href>http://maps.google.com/mapfiles/kml/shapes/open-diamond.png</href>"),
            "Expected KML to contain href to open diamond png")
        XCTAssertTrue(
            kml.contains("<color>ff000000</color>"),
            "Expected KML to contain black color for custom icon")
    }

    func testPushpinShapeIconURL() throws {
        let icon = IconStyle.predefined(type: .pushpin, color: .blue)
        let kml = icon.kmlString()
        XCTAssertTrue(
            kml.contains(
                "http://maps.google.com/mapfiles/kml/pushpin/blue-pushpin.png</href>")
        )
    }

    func testPredefinedIconsDoNotIncludeColorTag() throws {
        // Predefined icons should NOT include a color tag since color is in the URL
        let icon = IconStyle.predefined(type: .pushpin, color: .blue)
        let kml = icon.kmlString()

        XCTAssertFalse(kml.contains("<color>"), "Predefined icons should not include color tag")
        XCTAssertTrue(kml.contains("blue-pushpin.png"), "Should use blue pushpin URL")
    }

    func testScaleParameter() throws {
        let icon1 = IconStyle.predefined(type: .circle, color: .red, scale: 2.0)
        let kml1 = icon1.kmlString()
        XCTAssertTrue(kml1.contains("<scale>2.0</scale>"))

        let icon2 = IconStyle.custom(type: .triangle, color: .advisory, scale: 0.5)
        let kml2 = icon2.kmlString()
        XCTAssertTrue(kml2.contains("<scale>0.5</scale>"))
    }

    func test_iconStyle_transparentLocalPng_requiresKMZ_true() {
        let icon = IconStyle.transparentLocalPng(tint: .white, scale: 1.0)
        XCTAssertTrue(icon.requiresKMZ)
    }

    func test_iconStyle_customGoogleShape_requiresKMZ_false() {
        let icon = IconStyle.custom(type: .square, color: .white, scale: 1.0)
        XCTAssertFalse(icon.requiresKMZ)
    }

    func test_iconStyle_predefinedGooglePaddle_requiresKMZ_false() {
        let icon = IconStyle.predefined(type: .circle, color: .red, scale: 1.0)
        XCTAssertFalse(icon.requiresKMZ)
    }
}
