public enum KMZExportError: Error {
    case kmzRequired
    case missingLocalResource(String)
    case archiveCreationFailed
}
