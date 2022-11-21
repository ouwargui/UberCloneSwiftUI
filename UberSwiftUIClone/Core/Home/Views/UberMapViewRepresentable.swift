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
  let locationManager = LocationManager.shared
  @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
  @Binding var mapState: MapViewState

  func makeUIView(context: Context) -> some UIView {
    mapView.delegate = context.coordinator
    mapView.isRotateEnabled = false
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .none

    return mapView
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    print("DEBUG: Map state is \(mapState)")

    switch mapState {
    case .noInput:
      context.coordinator.clearMapViewAndRecenterOnUserLocation()
    case .locationSelected:
      if let coordinates = locationSearchViewModel.selectedUberLocation?.coordinate {
        context.coordinator.addAndSelectAnnotation(withCoordinate: coordinates)
        context.coordinator.configurePolyline(withDestinationCoordinate: coordinates)
      }
    case .searchingForLocation:
      break
    case .polylineAdded:
      break
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
    var currentRegion: MKCoordinateRegion?
    var isFirstRender = true

    init(parent: UberMapViewRepresentable) {
      self.parent = parent
      super.init()
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
      userLocationCoordinate = userLocation.coordinate
      let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      )

      currentRegion = region

      if isFirstRender {
        parent.mapView.setRegion(region, animated: true)
        isFirstRender = false
      }
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
    }

    func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
      guard let userLocationCoordinate = userLocationCoordinate else { return }

      parent.locationSearchViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
        self.parent.mapView.addOverlay(route.polyline, level: .aboveLabels)
        self.parent.mapState = .polylineAdded
        let rect = self.parent.mapView.mapRectThatFits(
          route.polyline.boundingMapRect,
          edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32)
        )
        self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
      }
    }

    func clearMapViewAndRecenterOnUserLocation() {
      parent.mapView.removeAnnotations(parent.mapView.annotations)
      parent.mapView.removeOverlays(parent.mapView.overlays)

      if let currentRegion = currentRegion {
        parent.mapView.setRegion(currentRegion, animated: true)
      }
    }
  }
}
