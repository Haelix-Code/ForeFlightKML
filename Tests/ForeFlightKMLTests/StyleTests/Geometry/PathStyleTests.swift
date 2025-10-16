import XCTest

@testable import ForeFlightKML

final class PathStylesTests: XCTestCase {

    func testPathStyleBasic() {
        let pathStyle = PathStyle(
            stroke: LineStyle(color: .advisory, width: 3.0)
        )

        let kml = pathStyle.kmlString()
        XCTAssertTrue(kml.contains("<Style id="))
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertTrue(kml.contains("<width>3.0</width>"))
    }

    func testPathStyleConvenienceInit() {
        let pathStyle = PathStyle(color: .warning, width: 5.0)

        let kml = pathStyle.kmlString()
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertTrue(kml.contains("<width>5.0</width>"))
    }

    func testPathStyleWithCustomId() {
        let pathStyle = PathStyle(
            color: .advisory,
            width: 2.5,
            id: "route-style"
        )

        XCTAssertEqual(pathStyle.id(), "route-style")
        let kml = pathStyle.kmlString()
        XCTAssertTrue(kml.contains("id=\"route-style\""))
    }

    func testPathStyleGeneratesUniqueIds() {
        let style1 = PathStyle(color: .advisory)
        let style2 = PathStyle(color: .clear)

        XCTAssertNotEqual(style1.id(), style2.id())
    }

    func testPathStyleDefaultWidth() {
        let pathStyle = PathStyle(color: .caution)
        let kml = pathStyle.kmlString()

        XCTAssertTrue(kml.contains("<width>2.0</width>"))
    }
}
