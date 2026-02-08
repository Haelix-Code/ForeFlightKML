import SwiftUI
import MapKit
import ForeFlightKML

struct ContentView: View {
    @State private var lastTapCoordinate: CLLocationCoordinate2D?
    @State private var kmlToShareURL: URL?

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
                    if let url = kmlToShareURL {
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .padding()
                                .background(Color(.systemBackground).opacity(0.9))
                                .clipShape(Circle())
                        }
                        .padding()
                    } else {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .padding()
                            .background(Color(.systemBackground).opacity(0.9))
                            .clipShape(Circle())
                            .opacity(0.4)
                            .padding()
                    }
                }
            }
        }
    }

    private func handleMapTap(_ coord: CLLocationCoordinate2D) {
        lastTapCoordinate = coord
        do {
            kmlToShareURL = try KMLGenerator.generateCircleKML(center: coord, radiusMeters: defaultRadiusMeters)
        } catch {
            print("Failed to generate KML: \(error)")
            kmlToShareURL = nil
        }
    }
}
