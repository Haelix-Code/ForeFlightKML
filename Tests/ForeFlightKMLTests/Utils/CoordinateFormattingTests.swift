import XCTest
import GeodesySpherical
@testable import ForeFlightKML

final class CoordinateFormattingTests: XCTestCase {

    // MARK: - formatCoordinate trailing zero trimming

    func testFormatCoordinate_roundValue_keepsOneDp() {
        XCTAssertEqual(formatCoordinate(2.0, precision: 8), "2.0")
        XCTAssertEqual(formatCoordinate(0.0, precision: 8), "0.0")
        XCTAssertEqual(formatCoordinate(-1.0, precision: 8), "-1.0")
        XCTAssertEqual(formatCoordinate(180.0, precision: 8), "180.0")
    }

    func testFormatCoordinate_trimsTrailingZeros() {
        XCTAssertEqual(formatCoordinate(51.123, precision: 8), "51.123")
        XCTAssertEqual(formatCoordinate(-1.581566, precision: 8), "-1.581566")
        XCTAssertEqual(formatCoordinate(0.1, precision: 8), "0.1")
        XCTAssertEqual(formatCoordinate(10.5, precision: 8), "10.5")
    }

    func testFormatCoordinate_fullPrecision_noTrimming() {
        XCTAssertEqual(formatCoordinate(51.12345678, precision: 8), "51.12345678")
        XCTAssertEqual(formatCoordinate(-0.00000001, precision: 8), "-0.00000001")
    }

    func testFormatCoordinate_respectsPrecisionParameter() {
        // Precision 4 rounds appropriately
        XCTAssertEqual(formatCoordinate(51.12345678, precision: 4), "51.1235")
        XCTAssertEqual(formatCoordinate(2.0, precision: 4), "2.0")
        XCTAssertEqual(formatCoordinate(1.5000, precision: 4), "1.5")

        // Precision 2
        XCTAssertEqual(formatCoordinate(51.12345678, precision: 2), "51.12")
        XCTAssertEqual(formatCoordinate(3.0, precision: 2), "3.0")

        // Precision 1
        XCTAssertEqual(formatCoordinate(51.12345678, precision: 1), "51.1")
        XCTAssertEqual(formatCoordinate(7.0, precision: 1), "7.0")
    }

    func testFormatCoordinate_negativeValues() {
        XCTAssertEqual(formatCoordinate(-77.036572, precision: 8), "-77.036572")
        XCTAssertEqual(formatCoordinate(-180.0, precision: 8), "-180.0")
    }

    // MARK: - Coordinate.kmlString with precision

    func testCoordinateKmlString_defaultPrecision() {
        let coord = Coordinate(latitude: 2.0, longitude: -1.0)
        XCTAssertEqual(coord.kmlString(), "-1.0,2.0")
    }

    func testCoordinateKmlString_customPrecision() {
        let coord = Coordinate(latitude: 51.12345678, longitude: -1.58156634)
        XCTAssertEqual(coord.kmlString(precision: 4), "-1.5816,51.1235")
        XCTAssertEqual(coord.kmlString(precision: 2), "-1.58,51.12")
    }

    // MARK: - Builder coordinatePrecision

    func testBuilder_defaultPrecision_is8() {
        let builder = ForeFlightKMLBuilder()
        XCTAssertEqual(builder.coordinatePrecision, 8)
    }

    func testBuilder_setCoordinatePrecision_chaining() {
        let builder = ForeFlightKMLBuilder()
            .setCoordinatePrecision(4)
        XCTAssertEqual(builder.coordinatePrecision, 4)
    }

    func testBuilder_setCoordinatePrecision_clampsRange() {
        let builder = ForeFlightKMLBuilder()
        builder.setCoordinatePrecision(0)
        XCTAssertEqual(builder.coordinatePrecision, 1)

        builder.setCoordinatePrecision(20)
        XCTAssertEqual(builder.coordinatePrecision, 15)
    }

    func testBuilder_precisionAffectsOutput() {
        let builder = ForeFlightKMLBuilder(documentName: "Test")
        builder.setCoordinatePrecision(4)

        builder.addPoint(
            name: "TestPoint",
            latitude: 51.12345678,
            longitude: -1.58156634,
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .pushpin, color: .white))
        )

        let result = try! builder.build(as: .kml)
        let kml = String(data: result.data, encoding: .utf8)!

        // With precision 4, coordinates should be trimmed to 4dp max
        XCTAssertTrue(kml.contains("-1.5816,51.1235"), "Expected 4dp coordinates in output. Got: \(kml)")
        // Should NOT contain 8dp coordinates
        XCTAssertFalse(kml.contains("-1.58156634"), "Should not have 8dp coordinates with precision 4")
    }

    func testBuilder_defaultPrecision_trimsTrailingZeros() {
        let builder = ForeFlightKMLBuilder(documentName: "Test")

        builder.addPoint(
            name: "Origin",
            latitude: 0.0,
            longitude: 0.0,
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .pushpin, color: .white))
        )

        let result = try! builder.build(as: .kml)
        let kml = String(data: result.data, encoding: .utf8)!

        // Should be "0.0,0.0" not "0.00000000,0.00000000"
        XCTAssertTrue(kml.contains("0.0,0.0"), "Expected trimmed coordinates. Got: \(kml)")
        XCTAssertFalse(kml.contains("0.00000000"), "Should not have trailing zeros")
    }
}
