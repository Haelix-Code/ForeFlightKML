enum BuildError: Error, Equatable {
    case missingAssetsForKMZ
    case unsupportedFeatureForKML
    case emptyArchive
    case internalError(underlying: Error)

    static func == (lhs: BuildError, rhs: BuildError) -> Bool {
        switch (lhs, rhs) {
        case (.missingAssetsForKMZ, .missingAssetsForKMZ): return true
        case (.unsupportedFeatureForKML, .unsupportedFeatureForKML): return true
        case (.emptyArchive, .emptyArchive): return true
        case (.internalError, .internalError):
            // Consider any internalError equal regardless of underlying Error
            return true
        default:
            return false
        }
    }
}
