import Foundation
import GeodesySpherical
import CoreLocation
import ForeFlightKML

enum KMLGenerator {
    /// Builds a KML file and writes it to a temp directory, returning the URL.
    static func generateCircleKML(center: CLLocationCoordinate2D, radiusMeters: Double) throws -> URL {
        let builder = ForeFlightKMLBuilder(documentName: "Foreflight KML Demo")

        let centerCoordinate = Coordinate(latitude: center.latitude, longitude: center.longitude)

        builder.addLineCircle(
            name: "Circle",
            center: centerCoordinate,
            radiusMeters: radiusMeters,
            numberOfPoints: 100,
            style: PathStyle(color: .black)
        )

        builder.addPolygonCircle(
            name: "Filled Circle",
            center: centerCoordinate,
            radiusMeters: radiusMeters * 2,
            style: PolygonStyle(outlineColor: .black, fillColor: .warning.withAlpha(0.3)))

        let result = try builder.build(as: .kml)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"

        let tmpURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(dateFormatter.string(from: Date())).\(result.fileExtension)")

        try result.data.write(to: tmpURL, options: [.atomic])
        return tmpURL
    }

    static func polygonCoordinatesForMap(center: CLLocationCoordinate2D, radiusMeters: Double) -> [CLLocationCoordinate2D] {
        let centerCoordinate = Coordinate(latitude: center.latitude, longitude: center.longitude)
        let circle = LineCircle(center: centerCoordinate, radius: radiusMeters, numberOfPoints: 100)
        return circle.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }
}
