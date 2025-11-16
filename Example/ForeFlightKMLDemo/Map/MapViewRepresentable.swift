import SwiftUI
import MapKit
import CoreLocation
import GeodesySpherical
import ForeFlightKML

struct MapViewRepresentable: UIViewRepresentable {
    let onTap: (CLLocationCoordinate2D) -> Void
    let radiusMeters: Double

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.delegate = context.coordinator
        map.showsUserLocation = true
        map.pointOfInterestFilter = .excludingAll
        map.setRegion(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.750188, longitude: -1.581566), latitudinalMeters: 2000, longitudinalMeters: 2000),
                      animated: false)

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        map.addGestureRecognizer(tap)
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // nothing for now
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        private var lastCircle: MKCircle?
        private var lastPolygon: MKPolygon?
        private var lastAnnotation: MKAnnotation?

        init(_ parent: MapViewRepresentable) { self.parent = parent }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let map = gesture.view as? MKMapView else { return }
            let pt = gesture.location(in: map)
            let coord = map.convert(pt, toCoordinateFrom: map)

            // remove existing visuals
            if let c = lastCircle { map.removeOverlay(c) }
            if let p = lastPolygon { map.removeOverlay(p) }
            if let a = lastAnnotation { map.removeAnnotation(a) }

            // add annotation
            let ann = MKPointAnnotation()
            ann.coordinate = coord
            ann.title = "Center"
            map.addAnnotation(ann)
            lastAnnotation = ann

            // add circle overlay (visual)
            let circle = MKCircle(center: coord, radius: parent.radiusMeters)
            map.addOverlay(circle)
            lastCircle = circle

            // polygon overlay matching the KML polygon (visual) – use package-provided points
            let polyCoords = KMLGenerator.polygonCoordinatesForMap(center: coord, radiusMeters: parent.radiusMeters)
            let polygon = MKPolygon(coordinates: polyCoords, count: polyCoords.count)
            map.addOverlay(polygon)
            lastPolygon = polygon

            // forward tap to SwiftUI
            parent.onTap(coord)
        }

        // renderers
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circle = overlay as? MKCircle {
                let r = MKCircleRenderer(circle: circle)
                r.strokeColor = UIColor.systemBlue
                r.lineWidth = 2
                r.fillColor = UIColor.systemBlue.withAlphaComponent(0.15)
                return r
            } else if let poly = overlay as? MKPolygon {
                let r = MKPolygonRenderer(polygon: poly)
                r.strokeColor = UIColor.systemRed
                r.lineWidth = 1.5
                r.fillColor = UIColor.systemRed.withAlphaComponent(0.08)
                return r
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
