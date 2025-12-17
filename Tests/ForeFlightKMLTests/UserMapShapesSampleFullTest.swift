import GeodesySpherical
import XCTest

@testable import ForeFlightKML

/// Recreates the example KML file for external testing
final class UserMapShapesRecreationTests: XCTestCase {

    func testGenerateCompleteExampleKML() throws {
        let builder = ForeFlightKMLBuilder(documentName: "FFIconTest.kml")

        builder.addLineCircle(
            name: "Circle",
            center: Coordinate(latitude: 32.907075, longitude: -99.460027),
            radiusMeters: 112166,
            style: PathStyle(color: .fromHex("0032ff"), width: 3.5)
        )

        let pushpins: [(name: String, color: DefinedIconColor, lon: Double)] = [
            ("ypin", .yellow, -102.6009416726494), ("bpin", .blue, -102.3009416726494),
            ("gpin", .green, -102.0009416726494), ("ltbpin", .lightblue, -101.7009416726494),
            ("pkpin", .pink, -101.4009416726494), ("ppin", .purple, -101.1009416726494),
            ("wpin", .white, -100.8009416726494)
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

        builder.addPoint(
            name: "gdiamond",
            coordinate: Coordinate(latitude: 32.53980174601483, longitude: -101.7009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .diamond, color: .green, scale: 1.1))
        )

        builder.addPoint(
            name: "gcircle",
            coordinate: Coordinate(latitude: 32.53980174601483, longitude: -101.4009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .circle, color: .green, scale: 1.1))
        )

        builder.addPoint(
            name: "gsquare",
            coordinate: Coordinate(latitude: 32.53980174601483, longitude: -101.1009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .square, color: .green, scale: 1.1))
        )

        builder.addPoint(
            name: "ltbdiamond",
            coordinate: Coordinate(latitude: 32.53980174601483, longitude: -100.8009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .diamond, color: .lightblue, scale: 1.1))
        )

        builder.addPoint(
            name: "ltbcircle",
            coordinate: Coordinate(latitude: 32.00980174601483, longitude: -102.6009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .circle, color: .lightblue, scale: 1.1))
        )

        builder.addPoint(
            name: "ltbsquare",
            coordinate: Coordinate(latitude: 32.00980174601483, longitude: -102.3009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .square, color: .lightblue, scale: 1.1))
        )

        builder.addPoint(
            name: "pkdiamond",
            coordinate: Coordinate(latitude: 32.00980174601483, longitude: -102.0009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .diamond, color: .pink, scale: 1.1))
        )

        builder.addPoint(
            name: "pkcircle",
            coordinate: Coordinate(latitude: 32.00980174601483, longitude: -101.7009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .circle, color: .pink, scale: 1.1))
        )

        builder.addPoint(
            name: "pksquare",
            coordinate: Coordinate(latitude: 32.00980174601483, longitude: -101.4009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .square, color: .pink, scale: 1.1))
        )

        builder.addPoint(
            name: "ydiamond",
            coordinate: Coordinate(latitude: 32.00980174601483, longitude: -101.1009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .diamond, color: .yellow, scale: 1.1)))
        builder.addPoint(
            name: "ycircle",
            coordinate: Coordinate(latitude: 32.00980174601483, longitude: -100.8009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .circle, color: .yellow, scale: 1.1)))
        builder.addPoint(
            name: "ysquare",
            coordinate: Coordinate(latitude: 31.60980174601483, longitude: -102.6009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .square, color: .yellow, scale: 1.1)))

        builder.addPoint(
            name: "wdiamond",
            coordinate: Coordinate(latitude: 31.60980174601483, longitude: -102.3009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .diamond, color: .white, scale: 1.1)))
        builder.addPoint(
            name: "wcircle",
            coordinate: Coordinate(latitude: 31.60980174601483, longitude: -102.0009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .circle, color: .white, scale: 1.1)))
        builder.addPoint(
            name: "wsquare",
            coordinate: Coordinate(latitude: 31.60980174601483, longitude: -101.7009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .square, color: .white, scale: 1.1)))

        builder.addPoint(
            name: "rdiamond",
            coordinate: Coordinate(latitude: 31.60980174601483, longitude: -101.4009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .diamond, color: .red, scale: 1.1)))
        builder.addPoint(
            name: "rcircle",
            coordinate: Coordinate(latitude: 31.60980174601483, longitude: -101.1009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .circle, color: .red, scale: 1.1)))
        builder.addPoint(
            name: "rsquare",
            coordinate: Coordinate(latitude: 31.60980174601483, longitude: -100.8009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .square, color: .red, scale: 1.1)))

        builder.addPoint(
            name: "pdiamond",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -102.6009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .diamond, color: .purple, scale: 1.1)))
        builder.addPoint(
            name: "pcircle",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -102.3009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .circle, color: .purple, scale: 1.1)))
        builder.addPoint(
            name: "psquare",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -102.0009416726494),
            altitude: 0,
            style: PointStyle(icon: .predefined(type: .square, color: .purple, scale: 1.1)))

        builder.addPoint(
            name: "forbidden",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -101.7009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .forbidden, scale: 1.2))
        )

        builder.addPoint(
            name: "opendiamond",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -101.4009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .opendiamond, scale: 1.2)
            )
        )

        builder.addPoint(
            name: "square",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -101.1009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .square, scale: 1.2)
            )
        )

        builder.addPoint(
            name: "target",
            coordinate: Coordinate(latitude: 31.10980174601483, longitude: -100.8009416726494),
            altitude: 0,
            style: PointStyle(icon: .custom(type: .target, scale: 1.2))
        )

        builder.addPoint(
            name: "triangle",
            coordinate: Coordinate(latitude: 30.60980174601483, longitude: -102.6009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .triangle, scale: 1.2),
            )
        )

        builder.addPoint(
            name: "pmsquare",
            coordinate: Coordinate(latitude: 30.60980174601483, longitude: -102.3009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .placemarksquare, scale: 1.2)
            )
        )

        builder.addPoint(
            name: "pmcircle",
            coordinate: Coordinate(latitude: 30.60980174601483, longitude: -102.0009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .placemarksquare, scale: 1.2)
            )
        )

        builder.addPoint(
            name: "ForbiddenR",
            coordinate: Coordinate(latitude: 30.60980174601483, longitude: -101.7009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .forbidden, color: .fromHex("FF0000"), scale: 1.2),
                label: LabelStyle(color: .fromHex("FF0000"))
            )
        )

        builder.addPoint(
            name: "SquareBl",
            coordinate: Coordinate(latitude: 30.60980174601483, longitude: -101.4009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .opendiamond, color: .black, scale: 1.2),
                label: LabelStyle(color: .black)
            )
        )

        builder.addPoint(
            name: "SquareO",
            coordinate: Coordinate(latitude: 30.60980174601483, longitude: -101.1009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .square, color: .fromHex("FFB001"), scale: 1.2),
                label: LabelStyle(color: .fromHex("FFB001"))
            )
        )

        builder.addPoint(
            name: "TriLG",
            coordinate: Coordinate(latitude: 30.60980174601483, longitude: -100.8009416726494),
            altitude: 0,
            style: PointStyle(
                icon: .custom(type: .triangle, color: .fromHex("BFF394"), scale: 1.2),
                label: LabelStyle(color: .fromHex("BFF394"))
            )
        )

        let pathCoords = [
            Coordinate(latitude: 33.29349602069717, longitude: -97.83722968666947),
            Coordinate(latitude: 31.29050449094128, longitude: -97.828182763451),
            Coordinate(latitude: 31.61232452550777, longitude: -98.5428285617465),
            Coordinate(latitude: 31.7047397632289, longitude: -100.3170555137615),
            Coordinate(latitude: 29.97078684118979, longitude: -100.3694632201026),
            Coordinate(latitude: 29.98839907481225, longitude: -97.94364952606627)
        ]

        builder.addLine(
            name: "Path Measure",
            coordinates: pathCoords,
            altitude: 0,
            tessellate: true,
            style: PathStyle(color: .fromHex("FF0000"), width: 5)
        )

        let polygonCoords = [
            Coordinate(latitude: 31.57870338920791, longitude: -100.1097399038377),
            Coordinate(latitude: 30.28600960074139, longitude: -100.1165273813259),
            Coordinate(latitude: 30.49650491542987, longitude: -98.96485321080908),
            Coordinate(latitude: 30.92214152160733, longitude: -98.95965359046227),
            Coordinate(latitude: 31.45369338953584, longitude: -99.09548335615463),
            Coordinate(latitude: 31.57870338920791, longitude: -100.1097399038377)
        ]

        builder.addPolygon(
            name: "Polygon",
            outerRing: polygonCoords,
            altitude: 0,
            tessellate: true,
            style: PolygonStyle(
                outline: LineStyle(color: .fromHex("30FF1E"), width: 1),
                fill: PolyStyle(color: .fromHex("FFFB0C"), fill: true)
            )
        )

        let emptyPolygonCoords = [
            Coordinate(latitude: 30.03052269669343, longitude: -99.82245544757197),
            Coordinate(latitude: 30.03901729880589, longitude: -98.42217483796792),
            Coordinate(latitude: 30.91879897233697, longitude: -98.45884346878807),
            Coordinate(latitude: 30.91463397098906, longitude: -98.82713860745589),
            Coordinate(latitude: 30.48700193733142, longitude: -98.86667174304488),
            Coordinate(latitude: 30.4076916783399, longitude: -98.9725084035981),
            Coordinate(latitude: 30.23278723698756, longitude: -100.0984043086122),
            Coordinate(latitude: 30.02246950700159, longitude: -100.10906670613),
            Coordinate(latitude: 30.03052269669343, longitude: -99.82245544757197)
        ]

        builder.addPolygon(
            name: "Empty Polygon",
            outerRing: emptyPolygonCoords,
            altitude: 0,
            tessellate: true,
            style: PolygonStyle(
                outline: LineStyle(color: .fromHex("30FF1E"), width: 6),
                fill: PolyStyle(color: .fromHex("FFFB0C"), fill: false)
            )
        )

        let kml = builder.build()
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("FFIconTest_Generated.kml")

        try kml.write(to: fileURL, atomically: true, encoding: .utf8)

        // Print the file path so you can easily find it
        print("\n" + String(repeating: "=", count: 80))
        print(" KML file generated successfully!")
        print(" Location: \(fileURL.path)")
        print(" Open in Finder: open \(tempDir.path)")
        print(String(repeating: "=", count: 80) + "\n")

        XCTAssertTrue(kml.contains("<Document>"))
        let placemarkCount = kml.components(separatedBy: "<Placemark>").count - 1
        XCTAssertEqual(placemarkCount, 46)
        print(" Stats:")
        print(" • Total placemarks: \(placemarkCount)")
        print(
            " • File size: \(ByteCountFormatter.string(fromByteCount: Int64(kml.utf8.count), countStyle: .file))"
        )
    }
}
