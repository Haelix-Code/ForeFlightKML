import XCTest
import GeodesySpherical
@testable import ForeFlightKML

final class ForeFlightKMLBuildTests: XCTestCase {

    func test_build_asKMZ_returnsExpectedMetadataAndHasDocKML() throws {
        let builder = ForeFlightKMLBuilder()
        builder.addPoint(
            name: "Normal",
            coordinate: Coordinate(latitude: 51.0, longitude: -1.0),
            altitude: 0,
            style: PointStyle(icon: .custom(type: .square, color: .white, scale: 1.0))
        )

        let result = try builder.build(as: .kmz)
        XCTAssertEqual(result.fileExtension, "kmz")
        XCTAssertEqual(result.mimetype, "application/vnd.google-earth.kmz")
        // Quick sanity check that archive contains doc.kml
        let archive = try ArchiveDataVerifier.archive(from: result.data)
        XCTAssertNotNil(archive["doc.kml"], "KMZ must contain doc.kml at root")
    }

    func test_build_asKML_whenNoKMZRequired_succeedsWithMetadata() throws {
        let builder = ForeFlightKMLBuilder()
        // Use a simple predefined icon that should not require local assets
        builder.addPoint(
            name: "Simple",
            coordinate: Coordinate(latitude: 0, longitude: 0)
        )

        XCTAssertFalse(builder.requiresKMZ)
        let result = try builder.build(as: .kml)
        XCTAssertEqual(result.fileExtension, "kml")
        XCTAssertEqual(result.mimetype, "application/vnd.google-earth.kml+xml")
        // Resulting data should decode as UTF-8 and contain KML root
        let kml = String(data: result.data, encoding: .utf8)
        XCTAssertNotNil(kml)
        XCTAssertTrue(kml?.contains("<kml ") == true)
    }

    func test_build_asKML_whenKMZRequired_throwsUnsupportedFeature() {
        let builder = ForeFlightKMLBuilder()
        // addLabel uses a local 1x1.png badge and therefore requires KMZ
        builder.addLabel("Badge", coordinate: Coordinate(latitude: 1, longitude: 1), color: .warning)
        XCTAssertTrue(builder.requiresKMZ)

        XCTAssertThrowsError(try builder.build(as: .kml)) { error in
            guard let buildError = error as? BuildError else {
                return XCTFail("Expected BuildError.unsupportedFeatureForKML, got: \(error)")
            }
            XCTAssertEqual(buildError, .unsupportedFeatureForKML)
        }
    }

    func test_setDocumentName_reflectedInOutput() {
        let builder = ForeFlightKMLBuilder()
        builder.setDocumentName("My Doc")
        builder.addPoint(name: "p", coordinate: Coordinate(latitude: 0, longitude: 0))

        let kml = builder.kmlString()
        XCTAssertTrue(kml.contains("<name>My Doc</name>"))
    }

    func test_clear_resetsState_counts_and_requiresKMZ() {
        let builder = ForeFlightKMLBuilder()
        builder.addPoint(name: "p", coordinate: Coordinate(latitude: 0, longitude: 0))
        builder.addLabel("Badge", coordinate: Coordinate(latitude: 1, longitude: 1), color: .warning)

        XCTAssertGreaterThan(builder.placemarkCount, 0)
        XCTAssertGreaterThan(builder.styleCount, 0)
        XCTAssertTrue(builder.requiresKMZ)

        builder.clear()

        XCTAssertEqual(builder.placemarkCount, 0)
        XCTAssertEqual(builder.styleCount, 0)
        XCTAssertFalse(builder.requiresKMZ)
    }
}

// MARK: - Local helper
import ZIPFoundation
private enum ArchiveDataVerifier {
    static func archive(from data: Data) throws -> Archive {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("kmz")
        try data.write(to: url)
        return try Archive(url: url, accessMode: .read)
    }
}
