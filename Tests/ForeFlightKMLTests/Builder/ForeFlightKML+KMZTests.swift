import XCTest
@testable import ForeFlightKML
import GeodesySpherical
import ZIPFoundation

final class KMZPackagingTests: XCTestCase {

    func test_buildKMZ_alwaysContainsDocKML() throws {
        let builder = ForeFlightKMLBuilder()
        builder.addPoint(
            name: "Normal",
            coordinate: Coordinate(latitude: 51.0, longitude: -1.0),
            altitude: 0,
            style: PointStyle(icon: .custom(type: .square, color: .white, scale: 1.0))
        )

        let kmz = try builder.buildKMZ()
        let archive = try makeArchive(from: kmz!)

        XCTAssertNotNil(archive["doc.kml"], "KMZ must contain doc.kml at root")
    }

    func test_buildKMZ_doesNotInclude1x1png_whenNotRequired() throws {
        let builder = ForeFlightKMLBuilder()
        builder.addPoint(
            name: "Normal",
            coordinate: Coordinate(latitude: 51.0, longitude: -1.0),
            altitude: 0,
            style: PointStyle(icon: .custom(type: .square, color: .white, scale: 1.0))
        )

        XCTAssertFalse(builder.requiresKMZ)

        let kmz = try builder.buildKMZ()
        let archive = try makeArchive(from: kmz!)

        XCTAssertNil(archive["1x1.png"], "KMZ should not include 1x1.png unless required")
    }

    func test_buildKMZ_includes1x1png_whenRequired() throws {
        let builder = ForeFlightKMLBuilder()
        builder.addLabel("Badge", coordinate: Coordinate(latitude: 51.0, longitude: -1.0), color: .warning)
        XCTAssertTrue(builder.requiresKMZ)

        let kmz = try builder.buildKMZ()
        let archive = try makeArchive(from: kmz!)

        XCTAssertNotNil(archive["1x1.png"], "KMZ must include 1x1.png when label badges are used")
    }

    // MARK: - Helpers

    private func makeArchive(from kmzData: Data) throws -> Archive {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("kmz")

        try kmzData.write(to: url)
        return try Archive(url: url, accessMode: .read)
    }

    func test_builderAddLabel() {
        let builder = ForeFlightKMLBuilder()

        builder.addLabel("Label Warning", coordinate: .init(latitude: 51.2345, longitude: -1.2345), color: .warning)
        do {
            let kmz = try builder.buildKMZ()

            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("test.kmz")

            try kmz!.write(to: url)
            print("KMZ written to:", url)
        } catch {
            XCTFail("Unable to build KMZ: \(error)")
        }
    }
}
