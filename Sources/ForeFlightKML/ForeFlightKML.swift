import Foundation
import GeodesySpherical

/// A Builder for composing a KML Document (styles + placemarks).
/// Use this to create KML documents compatible with ForeFlight's User Map Shapes feature.
///
public final class ForeFlightKMLBuilder {
    /// Optional name for the `<Document>` element.
    private var documentName: String?
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

    // MARK: - Build Methods

    /// Generate the complete KML string for this document.
    /// This method can be called multiple times - it doesn't modify the builder state.
    /// - Returns: A complete KML document as a UTF-8 string ready for export to ForeFlight
    public func build() -> String {
        return kmlString()
    }

    /// Produce the full KML string for this document.
    /// - Returns: A UTF-8 `String` containing the KML document.
    internal func kmlString() -> String {
        var documentComponents: [String] = []
        documentComponents.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
        let ns = namespaces.map { "\($0.key)=\"\($0.value)\"" }.joined(separator: " ")
        documentComponents.append("<kml \(ns)>")
        documentComponents.append("<Document>")
        if let name = documentName {
            documentComponents.append("<name>\(escapeForKML(name))</name>")
        }

        let stylesXML = styleManager.kmlString()
        if !stylesXML.isEmpty { documentComponents.append(stylesXML) }

        for placemark in placemarks { documentComponents.append(placemark.kmlString()) }

        documentComponents.append("</Document>")
        documentComponents.append("</kml>")

        return documentComponents.joined(separator: "\n")
    }

    /// Produce the KML document as `Data` using the given text encoding.
    /// - Parameter encoding: The `String.Encoding` to use when converting the KML string into data. Defaults to `.utf8`.
    /// - Returns: `Data` containing the encoded KML, or an empty `Data` if encoding fails.
    public func kmlData(encoding: String.Encoding = .utf8) -> Data {
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
