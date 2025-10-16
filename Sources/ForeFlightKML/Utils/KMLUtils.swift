/// Escapes key characters to be compliant with KML, used for names (Document, Placemark etc)
/// - Parameters:
///   - _ s: string to be escaped
///
/// - Returns: String
internal func escapeForKML(_ s: String) -> String {
    var out = s
    out = out.replacingOccurrences(of: "&", with: "&amp;")
    out = out.replacingOccurrences(of: "<", with: "&lt;")
    out = out.replacingOccurrences(of: ">", with: "&gt;")
    return out
}
