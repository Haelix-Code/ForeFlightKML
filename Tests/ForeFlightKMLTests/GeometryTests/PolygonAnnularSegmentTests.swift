import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class PolygonAnnularSegmentTests: XCTestCase {
    
    func testBasicAnnularSegment() throws {
        let builder = ForeFlightKMLBuilder(documentName: "Annular Test")
        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)
        
        let segment = PolygonAnnularSegment(
            center: center,
            innerRadius: 1000,  // 1km inner radius
            outerRadius: 2000,  // 2km outer radius
            startAngle: 0,      // North
            endAngle: 90        // East
        )
        
        let placemark = Placemark(name: "Northeast Quadrant", geometry: segment)
        builder.addPlacemark(placemark)
        let kml = builder.kmlString()
        
        XCTAssertTrue(kml.contains("<Placemark>"))
        XCTAssertTrue(kml.contains("Northeast Quadrant"))
        XCTAssertTrue(kml.contains("<Polygon>"))
        XCTAssertTrue(kml.contains("<outerBoundaryIs>"))
    }
    
    func testFourQuadrantAnnularSegments() throws {
        let builder = ForeFlightKMLBuilder(documentName: "Ring Quadrants")
        let center = Coordinate(latitude: 51.750188, longitude: -1.581566)
        
        let innerRadius: Double = 1000  // 1km
        let outerRadius: Double = 2000  // 2km
        
        let quadrants: [(name: String, start: Double, end: Double)] = [
            ("North", 0, 90),
            ("East", 90, 180),
            ("South", 180, 270),
            ("West", 270, 360)
        ]
        
        for quadrant in quadrants {
            builder.addPolygonAnnularSegment(
                name: quadrant.name,
                center: center,
                innerRadius: innerRadius,
                outerRadius: outerRadius,
                startAngle: quadrant.start,
                endAngle: quadrant.end,
                style: PolygonStyle(
                    outlineColor: .black,
                    fillColor: .warning.withAlpha(0.3)
                )
            )
        }
        
        let kml = builder.kmlString()
        
        XCTAssertTrue(kml.contains("North"))
        XCTAssertTrue(kml.contains("East"))
        XCTAssertTrue(kml.contains("South"))
        XCTAssertTrue(kml.contains("West"))
        
        let placemarkCount = kml.components(separatedBy: "<Placemark>").count - 1
        XCTAssertEqual(placemarkCount, 4)
    }
    
    func testAnnularSegmentWithStyle() throws {
        let builder = ForeFlightKMLBuilder(documentName: "Styled Ring")
        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)
        
        builder.addPolygonAnnularSegment(
            name: "Warning Sector",
            center: center,
            innerRadius: 1500,
            outerRadius: 3000,
            startAngle: 45,
            endAngle: 135,
            style: PolygonStyle(
                outlineColor: .warning,
                outlineWidth: 2.0,
                fillColor: .warning.withAlpha(0.4)
            )
        )
        
        let kml = builder.kmlString()
        
        XCTAssertTrue(kml.contains("Warning Sector"))
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertTrue(kml.contains("<PolyStyle>"))
    }
    
    func testAnnularSegmentCrossingNorth() throws {
        // Test a segment that crosses 0° (wraps around North)
        let builder = ForeFlightKMLBuilder(documentName: "Crossing North")
        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)
        
        let segment = PolygonAnnularSegment(
            center: center,
            innerRadius: 1000,
            outerRadius: 2000,
            startAngle: 330,  // 30° before North
            endAngle: 30      // 30° after North
        )
        
        builder.addPlacemark(Placemark(name: "North Crossing", geometry: segment))
        let kml = builder.kmlString()
        
        XCTAssertTrue(kml.contains("North Crossing"))
        XCTAssertTrue(kml.contains("<Polygon>"))
    }
    
    func testNarrowAnnularSegment() throws {
        // Test a thin ring segment (5° arc)
        let builder = ForeFlightKMLBuilder(documentName: "Narrow Segment")
        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)
        
        let segment = PolygonAnnularSegment(
            center: center,
            innerRadius: 1000,
            outerRadius: 2000,
            startAngle: 45,
            endAngle: 50,
            numberOfPoints: 16
        )
        
        builder.addPlacemark(Placemark(name: "Narrow", geometry: segment))
        let kml = builder.kmlString()
        
        XCTAssertTrue(kml.contains("Narrow"))
    }
    
    func testGenerateCompleteDemoKML() throws {
        let builder = ForeFlightKMLBuilder(documentName: "Annular Segments Demo")
        let center = Coordinate(latitude: 38.8700980, longitude: -77.055967)
        
        let innerRadius: Double = 1000
        let outerRadius: Double = 2000
        
        let quadrants: [(name: String, start: Double, end: Double, color: KMLColor)] = [
            ("North Quadrant", 0, 90, .warning),
            ("East Quadrant", 90, 180, .caution),
            ("South Quadrant", 180, 270, .advisory),
            ("West Quadrant", 270, 360, .fromHex("0000FF"))
        ]
        
        for quadrant in quadrants {
            builder.addPolygonAnnularSegment(
                name: quadrant.name,
                center: center,
                innerRadius: innerRadius,
                outerRadius: outerRadius,
                startAngle: quadrant.start,
                endAngle: quadrant.end,
                numberOfPoints: 64,
                style: PolygonStyle(
                    outlineColor: .black,
                    outlineWidth: 2.0,
                    fillColor: quadrant.color.withAlpha(0.4)
                )
            )
        }
        
        let kml = builder.build()
    
        XCTAssertTrue(kml.contains("<Document>"))
        let placemarkCount = kml.components(separatedBy: "<Placemark>").count - 1
        XCTAssertEqual(placemarkCount, 4)
    }
}
