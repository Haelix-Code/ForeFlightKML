# ForeFlightKML

> Swift framework to build KML files in Jeppesen ForeFlight friendly format. 

This package provides a small, focused API for composing KML documents suitable for importing into ForeFlight as **User Map Shapes (KML)**. It intentionally avoids UI concerns — it gives you `String` KML output (or bytes) which your app can write to disk and share using the standard iOS share sheet.
    
---

## Quick highlights

- Compose `Placemark`s with `Point`, `LineString`, `Polygon` and derived geometry helpers (circles, arc segments, etc.).
- Create reusable styles (`Style`, `LineStyle`, `PolyStyle`, `IconStyle`, `LabelStyle`) and assign them to placemarks.
- `ForeFlightKMLBuilder` collects placemarks and styles, emits a complete `kml` document string.
- Lightweight — no UI code.

---

## Install

1. In Xcode: **File › Add Packages...**
2. Enter the repository URL.
3. Choose the `ForeFlightKML` package product and add it to your app target.

---

## Example Output 
Using the example given on the [ForeFlight website](https://foreflight.com/support/user-map-shapes/) the below is generated using this Framework. 

See `/Tests/ForeFlightKMLTests/UserMapShapesSampleFullTest.swift`

<img width="615" height="770" alt="Image" src="https://github.com/user-attachments/assets/65da168d-e886-4ddf-8bc0-d4fa1f247331" />

## Minimal Quick Start

```swift
import ForeFlightKML
import Geodesy (we use this for Coordinate and relative positioniong)

// Example: Airport Traffic Pattern
let builder = ForeFlightKMLBuilder(documentName: "Airport with ATZ")

// Runway centerline
builder.addLine(
    name: "Runway 15-33", 
    coordinates: [Coordinate(latitude:, longitude:),Coordinate(latitude:, longitude:)],
    style: LineStyle(color: .black)
)

// Traffic Warning Area
builder.addLineCircle(
    name: "Airport ATZ", 
    center: airportCenter, 
    radiusMeters: 4630, // 2.5 nautical mile ATZ
    PolygonStyle(outlineColor: .black, fillColor: .warning.withAlpha(0.3))
)

let url = FileManager.default.temporaryDirectory.appendingPathComponent("shapes.kml")
try builder.build().write(to: url, atomically: true, encoding: .utf8)
presentShareSheet(with: url)
```

> **Note**: ForeFlight supports importing KML/KMZ files via the iOS share sheet. See ForeFlight's docs for exact import behavior.
---

## API quick reference (important types)

- `ForeFlightKMLBuilder` — builder for the KML document. Methods: `addPlacemark(_:)`, `kmlString()`.
- `Placemark` — a Feature containing a geometry (must implement `KMLElement`). Optionally attach a `KMLStyle`.
- Geometry types: `Point`, `Line`, `LineCircle`, `LineSegment` (segment of a Circle), `Polygon`, `PolygonCircle` (filled circle), `PolygonSegment` (filled segment) `LinearRing`.
- `Style` and substyles: `LineStyle`, `PolyStyle`, `IconStyle`, `LabelStyle`.
- `KMLColor` — helper to create the aabbggrr color values used by KML.

Full public API surface is visible in the package sources; the README examples show common usage patterns.

---

## Notes, conventions and gotchas

- **Coordinates order**: KML requires `longitude,latitude[,altitude]`. The public API accepts `Coordinate(latitude:..., longitude:...)` (from `Geodesy`) and the framework emits coordinates in the KML `lon,lat[,alt]` order.
- **Units**: Distances (e.g. `LineCircle.radius`) are in **meters**.
- **Angles/bearings**: bearings (for arc & circle generation) are interpreted in degrees (0..360). The bearing convention is clockwise from north.
- **Altitude**: When you provide altitudes, the `AltitudeMode` is emitted (defaults to `.absolute` in most geometries).
- **Styles**: `Style` generates a stable `id` when provided; otherwise a UUID-based id is generated. `ForeFlightKMLBuilder` will automatically register styles added via `Placemark`.
---

## Demo & tests

The repo contains an `Example` app that demonstrates building shapes and the `Tests` folder with unit tests. Before publishing, ensure the example builds and the tests run in CI.

---

## Contributing

PRs welcome. Please include unit tests for any new behavior and update examples.
