/// A minimal protocol that represents any top-level KML element that can be serialized
/// to a KML fragment string.
///
/// Implementers must produce valid KML (as a `String`) for that element.
public protocol KMLElement {
    func kmlString() -> String
    /// Write KML directly into a mutable string buffer for better performance.
    /// Default implementation falls back to `kmlString()`.
    func write(to buffer: inout String)
    /// Write KML with coordinate precision control.
    /// - Parameters:
    ///   - buffer: The string buffer to append to
    ///   - precision: Maximum decimal places for coordinates (trailing zeros are trimmed)
    func write(to buffer: inout String, precision: Int)
}

public extension KMLElement {
    func write(to buffer: inout String) {
        buffer.append(kmlString())
    }
    func write(to buffer: inout String, precision: Int) {
        write(to: &buffer)
    }
}

/// Represents a top-level KML `Style` that has an id and a KML body.
/// Use this to create reusable styles that placemarks can reference.
public protocol KMLStyle {
    // Top-level style that must provide an id and full KML (usually a <Style id="..."> ... </Style>)
    func id() -> String
    func kmlString() -> String
    /// Write style KML directly into a mutable string buffer for better performance.
    func write(to buffer: inout String)
    // Whether this style requires KMZ packaging (e.g. local icon assets).
    var requiresKMZ: Bool { get }
}

public extension KMLStyle {
    var requiresKMZ: Bool { false }
    func write(to buffer: inout String) {
        buffer.append(kmlString())
    }
}

/// Represents a style *sub-element* like `<LineStyle>` or `<PolyStyle>`.
/// These are embedded inside a top-level `<Style>`.
public protocol KMLSubStyle {
    // These produce the inner element tags (<LineStyle>...</LineStyle>, <PolyStyle>...</PolyStyle>).
    func kmlString() -> String
    /// Write sub-style KML directly into a mutable string buffer for better performance.
    func write(to buffer: inout String)
}

public extension KMLSubStyle {
    func write(to buffer: inout String) {
        buffer.append(kmlString())
    }
}

protocol Building {
    func build(as format: OutputFormat) throws -> BuildResult
}
