public enum ExportError: Error {
    case kmzRequired
    case missingLocalResource(String)
    case archiveCreationFailed
}

