import Foundation

public struct KMLBuildResult {
    public let data: Data
    public let fileExtension: String
    public let mimetype: String
}

protocol KMLBuilding {
    func build(as format: KMLFormat) throws -> KMLBuildResult
}

