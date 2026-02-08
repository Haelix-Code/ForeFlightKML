import Foundation
import GeodesySpherical

/// A Builder for composing a KML Document (styles + placemarks).
/// Use this to create KML documents compatible with ForeFlight's User Map Shapes feature.
///
/// - Note: Marked `@unchecked Sendable` because instances are intended
///   to be created, populated, and built within a single scope (not shared across threads).
///   This allows callers to use the builder from any actor/thread context.
public final class ForeFlightKMLBuilder: Building, @unchecked Sendable {
    /// Optional name for the `<Document>` element.
    private var documentName: String?
    /// Maximum decimal places for coordinate values. Trailing zeros are trimmed,
    /// so `2.0` stays as `"2.0"` rather than `"2.00000000"`. Default is 8.
    public var coordinatePrecision: Int = kDefaultCoordinatePrecision
    /// Collection of placemarks added to this builder.
    private var placemarks: [Placemark] = []
    /// Manages styles and deduplication
    private let styleManager = StyleManager()
    /// XML namespaces
    private let namespaces: [String: String] = [
        "xmlns": "http://www.opengis.net/kml/2.2",
        "xmlns:gx": "http://www.google.com/kml/ext/2.2",
        "xmlns:kml": "http://www.opengis.net/kml/2.2",
        "xmlns:atom": "http://www.w3.org/2005/Atom"
    ]

    /// Create a new builder.
    /// - Parameters:
    ///   - documentName: Optional name for the KML Document that appears in ForeFlight
    public init(documentName: String? = nil) {
        self.documentName = documentName
    }

    /// Set the document name.
    /// - Parameter name: The name to display in ForeFlight's document list
    /// - Returns: Self for method chaining
    @discardableResult
    public func setDocumentName(_ name: String?) -> Self {
        self.documentName = name
        return self
    }

    /// Set the maximum decimal places for coordinate values.
    /// Trailing zeros are always trimmed (e.g. `2.0` not `2.00000000`).
    /// - Parameter precision: Maximum decimal places (default 8, clamped to 1...15)
    /// - Returns: Self for method chaining
    @discardableResult
    public func setCoordinatePrecision(_ precision: Int) -> Self {
        self.coordinatePrecision = max(1, min(15, precision))
        return self
    }

    /// Add a placemark to the builder. The placemark's style (if present) will be registered.
    /// - Parameter placemark: Placemark to add.
    /// - Returns: Self for method chaining
    @discardableResult
    public func addPlacemark(_ placemark: Placemark) -> Self {
        placemarks.append(placemark)
        if let style = placemark.style {
            styleManager.register(style)
        }
        return self
    }

    /// True if this document must be exported as KMZ to render correctly.
    public var requiresKMZ: Bool {
        styleManager.requiresKMZ
    }

    // MARK: - Build Methods

    /// Generate the complete KML string for this document.
    /// This method can be called multiple times - it doesn't modify the builder state.
    /// - Returns: A complete KML document as a UTF-8 string ready for export to ForeFlight
    public func build(as format: OutputFormat = .kmz) throws -> BuildResult {
        if format == .kml, requiresKMZ {
            throw BuildError.unsupportedFeatureForKML
        }

        switch format {
        case .kml:
            let data = buildKML()
            return BuildResult(
                data: data,
                fileExtension: "kml",
                mimetype: "application/vnd.google-earth.kml+xml"
            )

        case .kmz:
            guard let data = try buildKMZ() else {
                throw BuildError.emptyArchive
            }
            return BuildResult(
                data: data,
                fileExtension: "kmz",
                mimetype: "application/vnd.google-earth.kmz"
            )
        }
    }

    /// Produce the full KML string for this document.
    /// - Returns: A UTF-8 `String` containing the KML document.
    internal func kmlString() -> String {
        // Pre-allocate a reasonable buffer size to avoid repeated reallocations
        var buffer = String()
        buffer.reserveCapacity(placemarks.count * 500 + 1000)

        buffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
        let ns = namespaces.map { "\($0.key)=\"\($0.value)\"" }.joined(separator: " ")
        buffer.append("<kml \(ns)>\n")
        buffer.append("<Document>\n")
        if let name = documentName {
            buffer.append("<name>\(escapeForKML(name))</name>\n")
        }

        styleManager.write(to: &buffer)

        for placemark in placemarks {
            placemark.write(to: &buffer, precision: coordinatePrecision)
        }

        buffer.append("</Document>\n")
        buffer.append("</kml>")

        return buffer
    }

    /// Produce the KML document as `Data` using the given text encoding.
    /// - Parameter encoding: The `String.Encoding` to use when converting the KML string into data. 
    /// - Returns: `Data` containing the encoded KML, or an empty `Data` if encoding fails.
    public func buildKML(encoding: String.Encoding = .utf8) -> Data {
        return kmlString().data(using: encoding) ?? Data()
    }

    // MARK: - Utility Methods
    /// Get the current number of placemarks in this builder.
    /// - Returns: Count of placemarks that will be included in the generated KML
    public var placemarkCount: Int {
        return placemarks.count
    }

    /// Get the current number of registered styles.
    /// - Returns: Count of unique styles that will be included in the generated KML
    public var styleCount: Int {
        return styleManager.styleCount
    }

    /// Remove all placemarks and styles from this builder.
    /// The defaultStyle will be re-registered automatically.
    /// - Returns: Self for method chaining
    @discardableResult
    public func clear() -> Self {
        placemarks.removeAll()
        styleManager.clear()
        return self
    }
}
