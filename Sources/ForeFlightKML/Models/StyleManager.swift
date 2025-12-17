/// Internal class responsible for managing styles and preventing duplicates in KML output.
/// Handles style registration, deduplication, and KML generation.
internal class StyleManager {
    private(set) var styles: [String: KMLStyle] = [:]
    private var referencedStyleIds: Set<String> = []

    // MARK: - Registration

    /// Register a style for inclusion in the KML document.
    /// If a style with the same ID already exists, the existing style is kept.
    /// - Parameter style: The style to register
    /// - Returns: The ID that was assigned to this style
    @discardableResult
    public func register(_ style: KMLStyle) -> String {
        let styleId = style.id()

        if styles[styleId] == nil {
            styles[styleId] = style
        }

        markAsReferenced(styleId)
        return styleId
    }

    /// Register multiple styles at once.
    /// - Parameter styles: Array of styles to register
    /// - Returns: Array of IDs assigned to the styles
    @discardableResult
    public func register(_ styles: [KMLStyle]) -> [String] {
        return styles.map { register($0) }
    }

    // MARK: - Reference Tracking

    /// Mark a style ID as being referenced by a placemark.
    /// This helps with cleanup of unused styles.
    /// - Parameter styleId: The style ID that is being used
    public func markAsReferenced(_ styleId: String) {
        referencedStyleIds.insert(styleId)
    }

    /// Mark multiple style IDs as referenced.
    /// - Parameter styleIds: Array of style IDs being used
    public func markAsReferenced(_ styleIds: [String]) {
        for styleId in styleIds {
            markAsReferenced(styleId)
        }
    }
    
    /// True if any referenced style requires KMZ packaging.
    var requiresKMZ: Bool {
        referencedStyleIds.contains { id in
            styles[id]?.requiresKMZ == true
        }
    }

    // MARK: - Style Management

    /// Get a style by its ID.
    /// - Parameter styleId: The style ID to look up
    /// - Returns: The style if found, nil otherwise
    public func style(for styleId: String) -> KMLStyle? {
        return styles[styleId]
    }

    /// Get count of registered styles.
    /// - Returns: Number of unique styles currently registered
    public var styleCount: Int {
        return styles.count
    }

    // MARK: - Cleanup

    /// Remove all styles and references.
    public func clear() {
        styles.removeAll()
        referencedStyleIds.removeAll()
    }

    /// Remove a specific style by ID.
    /// - Parameter styleId: The ID of the style to remove
    /// - Returns: true if the style was found and removed
    @discardableResult
    public func removeStyle(withId styleId: String) -> Bool {
        let removed = styles.removeValue(forKey: styleId) != nil
        referencedStyleIds.remove(styleId)
        return removed
    }

    // MARK: - KML Generation

    /// Generate the KML string for all registered styles.
    /// Only includes styles that have been marked as referenced.
    /// - Parameters:
    ///   - includeUnreferenced: If true, includes all registered styles even if not referenced (default: false)
    /// - Returns: KML string containing all style definitions
    public func kmlString() -> String {
        let stylesToOutput: [KMLStyle]

        stylesToOutput = styles.compactMap { styleId, style in
            referencedStyleIds.contains(styleId) ? style : nil
        }
        guard !stylesToOutput.isEmpty else {
            return ""
        }

        // Sort by ID for consistent output
        let sortedStyles = stylesToOutput.sorted { $0.id() < $1.id() }

        return
            sortedStyles
            .map { $0.kmlString() }
            .joined(separator: "\n")
    }
}
