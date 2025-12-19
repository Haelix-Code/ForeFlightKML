enum BuildError: Error {
    case missingAssetsForKMZ
    case unsupportedFeatureForKML
    case emptyArchive
    case internalError(underlying: Error)
}
