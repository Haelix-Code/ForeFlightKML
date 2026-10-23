import Foundation

public struct BuildResult: Sendable {
    public let data: Data
    public let fileExtension: String
    public let mimetype: String
}
