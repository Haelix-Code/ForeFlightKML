# ForeFlightKML

> Swift framework to build KML files in Jeppesen ForeFlight friendly format. 

This package provides a small, focused API for composing KML/KMZ documents suitable for importing into ForeFlight as **User Map Shapes (KML)**. It intentionally avoids UI concerns — it gives you `String` KML output (or bytes) which your app can write to disk and share using the standard iOS share sheet.
    

## Quick highlights

- Compose `Placemark`s with `Point`, `LineString`, `Polygon` and derived geometry helpers (circles, arc sectors, etc.).
- Create reusable styles (`Style`, `LineStyle`, `PolyStyle`, `IconStyle`, `LabelStyle`) and assign them to placemarks.
- `ForeFlightKMLBuilder` collects placemarks and styles, emits a complete `kml` or `kmz` document .
- Lightweight — no UI code.

## Install
1. In Xcode: **File › Add Packages...**
2. Enter the repository URL.
3. Choose the `ForeFlightKML` package product and add it to your app target.


## Example Output 
Using the example given on the [ForeFlight website](https://foreflight.com/support/user-map-shapes/) the below is generated using this Framework. 

See `/Tests/ForeFlightKMLTests/UserMapShapesSampleFullTest.swift`

<img width="615" height="770" alt="Image" src="/docs/example-output.png" />

## Quick Start

```swift
import ForeFlightKML
import Geodesy (used for coordinates)

let builder = ForeFlightKMLBuilder(documentName: "Airport with ATZ")
builder.addLine(
    name: "Runway 15-33", 
    coordinates: [Coordinate(latitude:, longitude:),Coordinate(latitude:, longitude:)],
    style: LineStyle(color: .black)
)

builder.addLineCircle(
    name: "Airport ATZ", 
    center: Coordinate(latitude:, longitude:), 
    radiusMeters: 4630,
    PolygonStyle(outlineColor: .black, fillColor: .warning.withAlpha(0.3))
)

let url = FileManager.default.temporaryDirectory.appendingPathComponent("shapes.kml")
try builder.build().write(to: url)
presentShareSheet(with: url)
```

> **Note**: ForeFlight supports importing KML/KMZ files via the iOS share sheet. See ForeFlight's docs for exact import behavior.


## API Reference

### KMLBuidler
 `ForeFlightKMLBuilder` is the builder for the KML/KMZ document. 
 - Document name can be set on `init` or with `setDocumentName()` 
 - Elements can be manually added using `addPlacemark(_:)`
 - The output is accessed by `try builder.build()`

### KMLBuilder Convenience Elements
 - `addPoint` Add a point with style.
 - `addLine` Add a line connecting multiple coordinates.
 - `addLineCircle` Add a circular line (approximated by line segments).
 - `addLineSector` Add an arc sector line geometry.
 - `addPolygon` Add a polygon with outer boundary and optional holes.
 - `addPolygonCircle` Add a polygon with outer boundary and optional holes.
 - `addPolygonSector` Add a filled sector polygon (pie slice).
 - `addPolygonAnnularSector` Add a filled annular (ring) sector polygon.
 - `addLabel` Add a text-only label placemark at a coordinate.

### ForeflightKMLBuilder Export formats
- Type `KMLBuildResult` contains: `data: Data`, `fileExtension: String` and `mimetype: String`
- `kml Data` via `builder.build(as: .kml)`
- `kmz Data` via `builder.buildKMZ(as: .kmz)`
- `kml String` via `builder.kmlString()` 
- KMZ (zipped KML) is required when using custom icons or using labelBadge (which uses a transparent .png under the hood). 

### Underlying elements
- `Placemark` — a Feature containing a geometry (must implement `KMLElement`). Optionally attach a `KMLStyle`.
- Geometry types: `Point`, `Line`, `LineCircle`, `LineSector` (sector of a Circle), `Polygon`, `PolygonCircle` (filled circle), `PolygonSector` (filled sector) `LinearRing`.
- `Style` and substyles: `LineStyle`, `PolyStyle`, `IconStyle`, `LabelStyle`.
- `KMLColor` — helper to create the aabbggrr color values used by KML.

Full public API surface is visible in the package sources.

## Notes, conventions and gotchas

- **Coordinates order**: KML requires `longitude,latitude[,altitude]`. The public API accepts `Coordinate(latitude:..., longitude:...)` (from `Geodesy`) and the framework emits coordinates in the KML `lon,lat[,alt]` order.
- **Units**: Distances (e.g. `LineCircle.radius`) are in **meters**.
- **Angles/bearings**: bearings (for arc & circle generation) are interpreted in degrees (0..360). The bearing convention is clockwise from north.
- **Altitude**: When you provide altitudes, the `AltitudeMode` is emitted (defaults to `.absolute` in most geometries).
- **Styles**: `Style` generates a stable `id` when provided; otherwise a UUID-based id is generated. `ForeFlightKMLBuilder` will automatically register styles added via `Placemark`.

## Demo & tests

The repo contains an `Example` app that demonstrates building shapes and the `Tests` folder with unit tests. 

## Contributing

PRs welcome. Please include unit tests for any new behavior and update examples.
