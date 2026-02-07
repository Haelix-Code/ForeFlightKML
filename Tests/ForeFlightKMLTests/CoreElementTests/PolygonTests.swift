import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class PolygonTests: XCTestCase {
    func makeRing(_ coords: [Coordinate], altitude: Double? = nil) -> LinearRing {
        return LinearRing(coordinates: coords, altitude: altitude)
    }

    func testKmlWithOuterOnly() {
        let outer = makeRing([
            Coordinate(latitude: 10, longitude: 20),
            Coordinate(latitude: 30, longitude: 40)
        ])
        let polygon = Polygon(outer: outer)
        let kml = polygon.kmlString()

        XCTAssertTrue(kml.contains("<Polygon>"))
        XCTAssertTrue(kml.contains("<outerBoundaryIs>"))

        XCTAssertTrue(
            kml.contains(
                """
                <coordinates>
                20.00000000,10.00000000
                40.00000000,30.00000000
                20.00000000,10.00000000
                </coordinates>
                """))
        XCTAssertTrue(kml.contains("40.00000000,30.00000000"))
        XCTAssertFalse(kml.contains("<innerBoundaryIs>"))
        XCTAssertFalse(kml.contains("<altitudeMode>"))
    }

    func testKmlWithInnerRingAndAltitude() {
        let outer = makeRing(
            [
                Coordinate(latitude: 0, longitude: 0),
                Coordinate(latitude: 1, longitude: 1)
            ],
            altitude: 50.0)
        let inner = makeRing(
            [
                Coordinate(latitude: 2, longitude: 2),
                Coordinate(latitude: 3, longitude: 3)
            ], altitude: 50.0)
        let polygon = Polygon(
            outer: outer, inner: [inner], altitudeMode: .absolute, tessellate: false)
        let kml = polygon.kmlString()

        XCTAssertTrue(kml.contains("<Polygon>"))
        XCTAssertTrue(kml.contains("<tessellate>0</tessellate>"))
        XCTAssertTrue(kml.contains("<outerBoundaryIs>"))
        XCTAssertTrue(kml.contains("<innerBoundaryIs>"))
        XCTAssertTrue(kml.contains("2.00000000,2.00000000,50.0"))
        XCTAssertTrue(kml.contains("3.00000000,3.00000000,50.0"))
        XCTAssertTrue(kml.contains("<altitudeMode>absolute</altitudeMode>"))
    }

    func testKmlWithSomeRingsWithoutAltitude() {
        let outer = makeRing(
            [
                Coordinate(latitude: 0, longitude: 0),
                Coordinate(latitude: 1, longitude: 1)
            ], altitude: nil)
        let inner = makeRing(
            [
                Coordinate(latitude: 2, longitude: 2),
                Coordinate(latitude: 3, longitude: 3)
            ], altitude: 20.0)
        let polygon = Polygon(
            outer: outer, inner: [inner], altitudeMode: .absolute, tessellate: false)
        let kml = polygon.kmlString()

        XCTAssertTrue(kml.contains("<Polygon>"))
        XCTAssertTrue(kml.contains("<altitudeMode>absolute</altitudeMode>"))
        XCTAssertTrue(kml.contains("2.00000000,2.00000000,20.0"))
        XCTAssertTrue(kml.contains("3.00000000,3.00000000,20.0"))
        XCTAssertTrue(kml.contains("0.00000000,0.00000000"))
        XCTAssertTrue(kml.contains("1.00000000,1.00000000"))
    }

    func testKmlWithAllRingsWithoutAltitude() {
        let outer = makeRing(
            [
                Coordinate(latitude: 0, longitude: 0),
                Coordinate(latitude: 1, longitude: 1)
            ], altitude: nil)
        let inner = makeRing(
            [
                Coordinate(latitude: 2, longitude: 2),
                Coordinate(latitude: 3, longitude: 3)
            ], altitude: nil)
        let polygon = Polygon(outer: outer, inner: [inner], tessellate: false)
        let kml = polygon.kmlString()

        XCTAssertFalse(kml.contains("<altitudeMode>"))
    }

    func test_polygon_withInnerRings_producesInnerBoundary() {
        let builder = ForeFlightKMLBuilder()
        let outer = [
            Coordinate(latitude: 0, longitude: 0),
            Coordinate(latitude: 0, longitude: 1),
            Coordinate(latitude: 1, longitude: 1)
        ]
        let hole = [
            Coordinate(latitude: 0.2, longitude: 0.2),
            Coordinate(latitude: 0.2, longitude: 0.8),
            Coordinate(latitude: 0.8, longitude: 0.8)
        ]

        builder.addPolygon(name: "poly", outerRing: outer, innerRings: [hole])
        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<innerBoundaryIs>"))
        XCTAssertTrue(kml.contains("<outerBoundaryIs>"))
    }
}
