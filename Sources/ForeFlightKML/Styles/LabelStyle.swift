/// Defines the visual appearance of text labels in ForeFlight.
///
/// LabelStyle controls how placemark names appear:
/// - Text color
/// - Visibility (implicitly - labels with matching background may be invisible)
///
/// Labels automatically appear next to or on their associated geometry.
/// The text content comes from the Placemark's name property.
///
public struct LabelStyle: KMLSubStyle {
    var color: KMLColor

    public init(color: KMLColor) {
        self.color = color
    }

    public func kmlString() -> String {
        let lines = [
            "<LabelStyle>",
            "<color>\(color.kmlHexString)</color>",
            "</LabelStyle>"
        ]
        return lines.joined(separator: "\n")
    }
}
