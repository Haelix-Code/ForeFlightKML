import SwiftUI
import MapKit

struct ContentView: View {
    @State private var lastTapCoordinate: CLLocationCoordinate2D?
    @State private var kmlToShareURL: URL?
    @State private var showingShare = false

    private let defaultRadiusMeters: Double = 500.0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapViewRepresentable(onTap: handleMapTap, radiusMeters: defaultRadiusMeters)
                .edgesIgnoringSafeArea(.all)

            VStack {
                if let coord = lastTapCoordinate {
                    Text(String(format: "Lat: %.5f\nLon: %.5f", coord.latitude, coord.longitude))
                        .padding(8)
                        .background(Color(.systemBackground).opacity(0.85))
                        .cornerRadius(8)
                        .padding(.top, 16)
                        .padding(.trailing, 12)
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: shareIfAvailable) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .padding()
                            .background(Color(.systemBackground).opacity(0.9))
                            .clipShape(Circle())
                    }
                    .disabled(kmlToShareURL == nil)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingShare) {
            if let url = kmlToShareURL {
                ActivityViewController(activityItems: [url])
            } else {
                Text("No KML available")
            }
        }
    }

    private func handleMapTap(_ coord: CLLocationCoordinate2D) {
        lastTapCoordinate = coord

        let kml = KMLGenerator.generateCircleKML(center: coord, radiusMeters: defaultRadiusMeters)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"

        let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(dateFormatter.string(from: Date())).kml")
        do {
            try kml.data(using: .utf8)?.write(to: tmpURL)
            kmlToShareURL = tmpURL
            showingShare = true
        } catch {
            print("Failed to write KML: \(error)")
            kmlToShareURL = nil
        }
    }

    private func shareIfAvailable() {
        if kmlToShareURL != nil {
            showingShare = true
        }
    }
}
