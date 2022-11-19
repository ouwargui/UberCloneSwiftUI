//
//  UberMapViewRepresentable.swift
//  UberSwiftUIClone
//
//  Created by Guilherme Santos on 18/11/22.
//

import MapKit
import SwiftUI

struct UberMapViewRepresentable: UIViewRepresentable {
  let mapView = MKMapView()
  let locationManager = LocationManager()
  @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel

  func makeUIView(context: Context) -> some UIView {
    mapView.delegate = context.coordinator
    mapView.isRotateEnabled = false
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow

    return mapView
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    if let coordinates = locationSearchViewModel.selectedLocationCoordinate {
      context.coordinator.addAndSelectAnnotation(withCoordinate: coordinates)
      context.coordinator.configurePolyline(withDestinationCoordinate: coordinates)
    }
  }

  func makeCoordinator() -> MapCoordinator {
    return MapCoordinator(parent: self)
  }
}

extension UberMapViewRepresentable {
  class MapCoordinator: NSObject, MKMapViewDelegate {
    let parent: UberMapViewRepresentable
    var userLocationCoordinate: CLLocationCoordinate2D?

    init(parent: UberMapViewRepresentable) {
      self.parent = parent
      super.init()
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
      userLocationCoordinate = userLocation.coordinate
      let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

      parent.mapView.setRegion(region, animated: true)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let polyline = MKPolylineRenderer(overlay: overlay)
      polyline.strokeColor = .systemBlue
      polyline.lineWidth = 6
      return polyline
    }

    func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
      parent.mapView.removeAnnotations(parent.mapView.annotations)

      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      parent.mapView.addAnnotation(annotation)
      parent.mapView.selectAnnotation(annotation, animated: true)

      parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
    }

    func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
      guard let userLocationCoordinate = userLocationCoordinate else { return }
      getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
        self.parent.mapView.addOverlay(route.polyline, level: .aboveLabels)
      }
    }

    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (MKRoute) -> Void) {
      let userPlacemark = MKPlacemark(coordinate: userLocation)
      let destinationPlacemark = MKPlacemark(coordinate: destination)
      let request = MKDirections.Request()
      request.source = MKMapItem(placemark: userPlacemark)
      request.destination = MKMapItem(placemark: destinationPlacemark)
      let directions = MKDirections(request: request)

      directions.calculate { response, error in
        if let error = error {
          print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
          return
        }

        guard let route = response?.routes.first else { return }
        completion(route)
      }
    }
  }
}
