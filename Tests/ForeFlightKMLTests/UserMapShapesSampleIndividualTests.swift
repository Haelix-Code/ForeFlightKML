import GeodesySpherical
import XCTest

@testable import ForeFlightKML

final class ExampleKMLRecreationTests: XCTestCase {

    func testYellowPushpin() {
        let style = PointStyle(
            icon: .predefined(type: .pushpin, color: .yellow, scale: 1.1),
            id: "s_ylw-pushpin"
        )

        let builder = ForeFlightKMLBuilder(documentName: "FFIconTest.kml")
        builder.addPoint(
            name: "ypin",
            coordinate: Coordinate(latitude: 33.13980174601483, longitude: -102.6009416726494),
            altitude: 0,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>ypin</name>"))
        XCTAssertTrue(kml.contains("ylw-pushpin.png"))
        XCTAssertTrue(kml.contains("-102.6009416726494,33.13980174601483,0"))
    }

    func testBluePushpin() {
        let style = PointStyle(
            icon: .predefined(type: .pushpin, color: .blue, scale: 1.1),
            id: "sn_blue-pushpin"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addPoint(
            name: "bpin",
            coordinate: Coordinate(latitude: 33.13980174601483, longitude: -102.3009416726494),
            altitude: 0,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>bpin</name>"))
        print(kml)
        XCTAssertTrue(kml.contains("blue-pushpin.png"))
    }

    func testAllPushpins() {
        let builder = ForeFlightKMLBuilder(documentName: "Pushpin Test")

        let pushpins: [(name: String, color: DefinedIconColor, lon: Double)] = [
            ("ypin", .yellow, -102.6009416726494),
            ("bpin", .blue, -102.3009416726494),
            ("gpin", .green, -102.0009416726494),
            ("ltbpin", .lightblue, -101.7009416726494),
            ("pkpin", .pink, -101.4009416726494),
            ("ppin", .purple, -101.1009416726494),
            ("wpin", .white, -100.8009416726494),
        ]

        for pushpin in pushpins {
            builder.addPoint(
                name: pushpin.name,
                coordinate: Coordinate(latitude: 33.13980174601483, longitude: pushpin.lon),
                altitude: 0,
                style: PointStyle(
                    icon: .predefined(type: .pushpin, color: pushpin.color, scale: 1.1))
            )
        }

        let kml = builder.kmlString()
        for pushpin in pushpins {
            XCTAssertTrue(kml.contains("<name>\(pushpin.name)</name>"))
        }
    }

    func testBlueShapes() {
        let builder = ForeFlightKMLBuilder(documentName: "Blue Shapes")

        builder.addPoint(
            name: "bdiamond",
            coordinate: Coordinate(latitude: 32.53980174601483, longitude: -102.6009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .diamond, color: .blue, scale: 1.1))
        )

        builder.addPoint(
            name: "bcircle",
            coordinate: Coordinate(latitude: 32.53980174601483, longitude: -102.3009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .circle, color: .blue, scale: 1.1))
        )

        builder.addPoint(
            name: "bsquare",
            coordinate: Coordinate(latitude: 32.53980174601483, longitude: -102.0009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .square, color: .blue, scale: 1.1))
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("blu-diamond.png"))
        XCTAssertTrue(kml.contains("blu-circle.png"))
        XCTAssertTrue(kml.contains("blu-square.png"))
    }

    func testAllColorShapeCombinations() {
        let builder = ForeFlightKMLBuilder(documentName: "All Shapes")

        let shapes: [(color: DefinedIconColor, lat: Double)] = [
            (.blue, 32.53980174601483),
            (.green, 32.53980174601483),
            (.lightblue, 32.53980174601483),
            (.pink, 32.00980174601483),
            (.yellow, 32.00980174601483),
            (.white, 31.60980174601483),
            (.red, 31.60980174601483),
            (.purple, 31.10980174601483),
        ]

        let types: [(type: PredefinedIconType, lonOffset: Double, suffix: String)] = [
            (.diamond, 0.0, "diamond"),
            (.circle, 0.3, "circle"),
            (.square, 0.6, "square"),
        ]

        for (index, shape) in shapes.enumerated() {
            let baseLon = -102.6009416726494 + Double(index) * 0.3
            for type in types {
                let name = "\(shape.color)\(type.suffix)"
                builder.addPoint(
                    name: name,
                    coordinate: Coordinate(
                        latitude: shape.lat, longitude: baseLon + type.lonOffset),
                    altitude: 0,
                    style: PointStyle(
                        icon: .predefined(type: type.type, color: shape.color, scale: 1.1))
                )
            }
        }

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("diamond"))
        XCTAssertTrue(kml.contains("circle"))
        XCTAssertTrue(kml.contains("square"))
    }

    // MARK: - Custom Icon Tests

    func testForbiddenIcon() {
        let style = PointStyle(
            icon: .custom(type: .forbidden, color: .fromHex("0000FF"), scale: 1.2),
            label: LabelStyle(color: .fromHex("0000FF")),
            id: "sn_forbidden0"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addPoint(
            name: "forbidden",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -101.7009416726494),
            altitude: 0,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>forbidden</name>"))
        XCTAssertTrue(kml.contains("forbidden.png"))
        XCTAssertTrue(kml.contains("<LabelStyle>"))
    }

    func testOpenDiamondIcon() {
        let style = PointStyle(
            icon: .custom(type: .opendiamond, color: .black, scale: 1.2),
            label: LabelStyle(color: .black),
            id: "sn_open-diamond"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addPoint(
            name: "opendiamond",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -101.4009416726494),
            altitude: 0,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>opendiamond</name>"))
        XCTAssertTrue(kml.contains("open-diamond.png"))
    }

    func testTargetIcon() {
        let style = PointStyle(
            icon: .custom(type: .target, color: .black, scale: 1.2),
            id: "sn_target"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addPoint(
            name: "target",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -100.8009416726494),
            altitude: 0,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>target</name>"))
        XCTAssertTrue(kml.contains("target.png"))
    }

    func testTriangleIcon() {
        let style = PointStyle(
            icon: .custom(type: .triangle, color: .fromHex("BFF394"), scale: 1.2),
            label: LabelStyle(color: .fromHex("FEA109")),
            id: "sn_triangle"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addPoint(
            name: "triangle",
            coordinate: Coordinate(latitude: 30.60980174601483, longitude: -102.6009416726494),
            altitude: 0,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>triangle</name>"))
        XCTAssertTrue(kml.contains("triangle.png"))
        XCTAssertTrue(kml.contains("<LabelStyle>"))
    }

    func testTriLGIcon() {
        let style = PointStyle(
            icon: .custom(type: .triangle, color: .fromHex("BFF394"), scale: 1.2),
            label: LabelStyle(color: .fromHex("FEA109")),
            id: "sn_triangle0"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addPoint(
            name: "TriLG",
            coordinate: Coordinate(latitude: 30.60980174601483, longitude: -100.8009416726494),
            altitude: 0,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>TriLG</name>"))
        XCTAssertTrue(kml.contains("triangle.png"))
    }

    // MARK: - LineString Tests

    func testCircleLineString() {
        let circleCoords: [(lon: Double, lat: Double, alt: Double)] = [
            (-100.6451262280923, 32.90340732536495, 662.9205172240112),
            (-100.6415253336444, 32.99137087501826, 656.9518519692371),
            (-100.6287822500505, 33.07873557406999, 651.7252962731609),
            (-100.6451262280923, 32.90340732536495, 662.9205172240112),  // Closing coordinate
        ]

        let coords = circleCoords.map { Coordinate(latitude: $0.lat, longitude: $0.lon) }

        let style = PathStyle(
            color: .fromHex("FF3200"),
            width: 3.5,
            id: "inline6"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addLine(
            name: "Circle",
            coordinates: coords,
            tessellate: true,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>Circle</name>"))
        XCTAssertTrue(kml.contains("<tessellate>1</tessellate>"))
        XCTAssertTrue(kml.contains("<LineString>"))
    }

    func testPathMeasure() {
        let pathCoords = [
            Coordinate(latitude: 33.29349602069717, longitude: -97.83722968666947),
            Coordinate(latitude: 31.29050449094128, longitude: -97.828182763451),
            Coordinate(latitude: 31.61232452550777, longitude: -98.5428285617465),
            Coordinate(latitude: 31.7047397632289, longitude: -100.3170555137615),
            Coordinate(latitude: 29.97078684118979, longitude: -100.3694632201026),
            Coordinate(latitude: 29.98839907481225, longitude: -97.94364952606627),
        ]

        let style = PathStyle(
            color: .fromHex("0000FF"),
            width: 5,
            id: "inline5"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addLine(
            name: "Path Measure",
            coordinates: pathCoords,
            altitude: 0,
            tessellate: true,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>Path Measure</name>"))
        XCTAssertTrue(kml.contains("<tessellate>1</tessellate>"))
        XCTAssertTrue(kml.contains("<width>5"))
    }

    func testPolygon() {
        let coords = [
            Coordinate(latitude: 31.57870338920791, longitude: -100.1097399038377),
            Coordinate(latitude: 30.28600960074139, longitude: -100.1165273813259),
            Coordinate(latitude: 30.49650491542987, longitude: -98.96485321080908),
            Coordinate(latitude: 30.92214152160733, longitude: -98.95965359046227),
            Coordinate(latitude: 31.45369338953584, longitude: -99.09548335615463),
            Coordinate(latitude: 31.57870338920791, longitude: -100.1097399038377),
        ]

        let style = PolygonStyle(
            outline: LineStyle(color: .fromHex("30FF1E"), width: 6),
            fill: PolyStyle(color: .fromHex("FFFB0C"), fill: false),
            id: "inline3"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addPolygon(
            name: "Polygon",
            outerRing: coords,
            altitude: 0,
            tessellate: true,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>Polygon</name>"))
        XCTAssertTrue(kml.contains("<tessellate>1</tessellate>"))
        XCTAssertTrue(kml.contains("<outerBoundaryIs>"))
        XCTAssertTrue(kml.contains("<LinearRing>"))
        XCTAssertTrue(kml.contains("<fill>0</fill>"))
    }

    func testEmptyPolygon() {
        let coords = [
            Coordinate(latitude: 30.03052269669343, longitude: -99.82245544757197),
            Coordinate(latitude: 30.03901729880589, longitude: -98.42217483796792),
            Coordinate(latitude: 30.91879897233697, longitude: -98.45884346878807),
            Coordinate(latitude: 30.91463397098906, longitude: -98.82713860745589),
            Coordinate(latitude: 30.48700193733142, longitude: -98.86667174304488),
            Coordinate(latitude: 30.4076916783399, longitude: -98.9725084035981),
            Coordinate(latitude: 30.23278723698756, longitude: -100.0984043086122),
            Coordinate(latitude: 30.02246950700159, longitude: -100.10906670613),
            Coordinate(latitude: 30.03052269669343, longitude: -99.82245544757197),
        ]

        let style = PolygonStyle(
            outline: LineStyle(color: .fromHex("30FF1E")),
            fill: PolyStyle(color: .fromHex("FFFB0C"), fill: false),
            id: "inline30"
        )

        let builder = ForeFlightKMLBuilder()
        builder.addPolygon(
            name: "Empty Polygon",
            outerRing: coords,
            altitude: 0,
            tessellate: true,
            style: style
        )

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>Empty Polygon</name>"))
        XCTAssertTrue(kml.contains("<outerBoundaryIs>"))
        XCTAssertTrue(kml.contains("<fill>0</fill>"))
    }

    func testCompleteDocumentRecreation() {
        let builder = ForeFlightKMLBuilder(documentName: "FFIconTest.kml")

        // Add a sample of each type
        builder.addPoint(
            name: "ypin",
            coordinate: Coordinate(latitude: 33.13980174601483, longitude: -102.6009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .pushpin, color: .yellow, scale: 1.1))
        )

        builder.addPoint(
            name: "forbidden",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -101.7009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .forbidden, color: .fromHex("0000FF"), scale: 1.2),
                label: LabelStyle(color: .fromHex("0000FF"))
            )
        )

        let pathCoords = [
            Coordinate(latitude: 33.29349602069717, longitude: -97.83722968666947),
            Coordinate(latitude: 31.29050449094128, longitude: -97.828182763451),
        ]

        builder.addLine(
            name: "Path Measure",
            coordinates: pathCoords,
            altitude: 0,
            tessellate: true,
            style: PathStyle(color: .fromHex("0000FF"), width: 5)
        )

        let polygonCoords = [
            Coordinate(latitude: 31.57870338920791, longitude: -100.1097399038377),
            Coordinate(latitude: 30.28600960074139, longitude: -100.1165273813259),
            Coordinate(latitude: 30.49650491542987, longitude: -98.96485321080908),
        ]

        builder.addPolygon(
            name: "Polygon",
            outerRing: polygonCoords,
            altitude: 0,
            tessellate: true,
            style: PolygonStyle(
                outline: LineStyle(color: .fromHex("30FF1E")),
                fill: PolyStyle(color: .fromHex("FFFB0C"), fill: false)
            )
        )

        let kml = builder.kmlString()

        XCTAssertTrue(kml.contains("<Document>"))
        XCTAssertTrue(kml.contains("<name>FFIconTest.kml</name>"))
        XCTAssertTrue(kml.contains("</Document>"))

        XCTAssertTrue(kml.contains("<Style id="))
        XCTAssertTrue(kml.contains("<IconStyle>"))
        XCTAssertTrue(kml.contains("<LineStyle>"))
        XCTAssertTrue(kml.contains("<PolyStyle>"))

        XCTAssertTrue(kml.contains("<Placemark>"))
        XCTAssertTrue(kml.contains("<Point>"))
        XCTAssertTrue(kml.contains("<LineString>"))
        XCTAssertTrue(kml.contains("<Polygon>"))

        let placemarkCount = kml.components(separatedBy: "<Placemark>").count - 1
        XCTAssertEqual(placemarkCount, 4)
    }
}
