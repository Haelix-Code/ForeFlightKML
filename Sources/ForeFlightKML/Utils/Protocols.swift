/// A minimal protocol that represents any top-level KML element that can be serialized
/// to a KML fragment string.
///
/// Implementers must produce valid KML (as a `String`) for that element.
public protocol KMLElement {
    func kmlString() -> String
}

/// Represents a top-level KML `Style` that has an id and a KML body.
/// Use this to create reusable styles that placemarks can reference.
public protocol KMLStyle {
    // Top-level style that must provide an id and full KML (usually a <Style id="..."> ... </Style>)
    func id() -> String
    func kmlString() -> String
    // Whether this style requires KMZ packaging (e.g. local icon assets).
    var requiresKMZ: Bool { get }
}

public extension KMLStyle {
    var requiresKMZ: Bool { false }
}

/// Represents a style *sub-element* like `<LineStyle>` or `<PolyStyle>`.
/// These are embedded inside a top-level `<Style>`.
public protocol KMLSubStyle {
    // These produce the inner element tags (<LineStyle>...</LineStyle>, <PolyStyle>...</PolyStyle>).
    func kmlString() -> String
}
