import XCTest
import GeodesySpherical
@testable import ForeFlightKML

class XMLTestHelper {
    /// Parse KML fragment by wrapping it in a complete KML document with proper namespaces
    static func parseKMLFragment(_ kmlFragment: String) throws -> XMLDocument {
        let completeKML = """
            <?xml version="1.0" encoding="UTF-8"?>
            <kml xmlns="http://www.opengis.net/kml/2.2"
                 xmlns:gx="http://www.google.com/kml/ext/2.2"
                 xmlns:kml="http://www.opengis.net/kml/2.2"
                 xmlns:atom="http://www.w3.org/2005/Atom">
            <Document>
            \(kmlFragment)
            </Document>
            </kml>
            """

        let data = Data(completeKML.utf8)
        return try XMLDocument(data: data, options: [])
    }

    /// Extract all elements of a given name from XML, handling namespaces
    static func extractElements(named elementName: String, from xml: XMLDocument) throws -> [XMLElement] {
        // Try both with and without namespace prefix
        let xpathQueries = [
            "//\(elementName)",
            "//kml:\(elementName)",
            "//gx:\(elementName)"
        ]

        var allElements: [XMLElement] = []

        for query in xpathQueries {
            do {
                let nodes = try xml.nodes(forXPath: query)
                allElements.append(contentsOf: nodes.compactMap { $0 as? XMLElement })
            } catch {
                continue
            }
        }

        return allElements
    }

    /// Get text content from first element with given name, handling namespaces
    static func getTextContent(elementName: String, from xml: XMLDocument) throws -> String? {
        let elements = try extractElements(named: elementName, from: xml)
        return elements.first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Validate that XML contains expected structure
    static func validateStructure(_ xml: XMLDocument, expectedElements: [String]) throws {
        for elementName in expectedElements {
            let elements = try extractElements(named: elementName, from: xml)
            XCTAssertFalse(elements.isEmpty, "Missing required element: \(elementName)")
        }
    }

    /// Parse coordinates string into array of coordinate components
    static func parseCoordinates(_ coordinateString: String) -> [CoordinateComponent] {
        let lines = coordinateString.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        return lines.compactMap { line in
            let parts = line.components(separatedBy: ",")
            return CoordinateComponent(from: parts)
        }
    }
}

struct CoordinateComponent {
    let longitude: Double
    let latitude: Double
    let altitude: Double?
}

extension CoordinateComponent {
    init?(from parts: [String]) {
        guard parts.count >= 2,
              let lon = Double(parts[0]),
              let lat = Double(parts[1]) else {
            return nil
        }

        self.longitude = lon
        self.latitude = lat
        self.altitude = parts.count >= 3 ? Double(parts[2]) : nil
    }
}
