import Foundation
import ZIPFoundation

public extension ForeFlightKMLBuilder {

    /// Build a KMZ (ZIP) containing doc.kml and any required local assets.
    func buildKMZ() throws -> Data? {

        // Build KML string directly, then convert to UTF-8 data once
        let kmlString = kmlString()
        guard let kmlData = kmlString.data(using: .utf8) else {
            return nil
        }

        let archive = try Archive(accessMode: .create)

        // Use .none compression for small documents (< 100KB) to avoid DEFLATE overhead
        let compressionMethod: CompressionMethod = kmlData.count > 100_000 ? .deflate : .none

        try archive.addEntry(
            with: "doc.kml",
            type: .file,
            uncompressedSize: Int64(kmlData.count),
            compressionMethod: compressionMethod,
            provider: { position, size in
                let start = Int(position)
                guard start < kmlData.count else { return Data() }
                let end = min(start + size, kmlData.count)
                return kmlData.subdata(in: start..<end)
            }
        )

        if requiresKMZ {
            try addLocalAssets(to: archive)
        }

        return archive.data
    }
}

private extension ForeFlightKMLBuilder {

    func addLocalAssets(to archive: Archive) throws {

        let bundle = Bundle.module

        guard let iconURL = bundle.url(forResource: "1x1", withExtension: "png") else {
            throw ExportError.missingLocalResource("1x1.png")
        }

        try archive.addEntry(
            with: "1x1.png",
            fileURL: iconURL,
            compressionMethod: .deflate
        )
    }
}
