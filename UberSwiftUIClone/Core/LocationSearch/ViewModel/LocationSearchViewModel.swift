//
//  LocationSearchViewModel.swift
//  UberSwiftUIClone
//
//  Created by Guilherme Santos on 18/11/22.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
  @Published var results = [MKLocalSearchCompletion]()
  @Published var selectedUberLocation: UberLocation?
  @Published var pickupTime: String?
  @Published var dropOffTime: String?

  private let searchCompleter = MKLocalSearchCompleter()

  var queryFragment: String = "" {
    didSet {
      searchCompleter.queryFragment = queryFragment
    }
  }

  var userLocation: CLLocationCoordinate2D?

  override init() {
    super.init()
    searchCompleter.delegate = self
    searchCompleter.queryFragment = queryFragment
  }

  func selectLocation(_ localSearch: MKLocalSearchCompletion) {
    locationSearch(forLocalSearchCompletion: localSearch) { response, error in
      if let error = error {
        print("DEBUG: Selected location error - \(error.localizedDescription)")
        return
      }

      guard let item = response?.mapItems.first else { return }
      let coordinate = item.placemark.coordinate
      self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)

      print("DEBUG: Selected location coordinates \(coordinate)")
    }
  }

  func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)

    let search = MKLocalSearch(request: searchRequest)
    search.start(completionHandler: completion)
  }

  func computeRidePrice(forType type: RideType) -> Double {
    guard let coordinate = selectedUberLocation?.coordinate else { return 0 }
    guard let userLocationCoordinate2D = userLocation else { return 0 }

    let userLocationCoordiante = CLLocation(
      latitude: userLocationCoordinate2D.latitude,
      longitude: userLocationCoordinate2D.longitude)
    let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

    let tripDistanceInMeters = userLocationCoordiante.distance(from: destination)
    return type.computePrice(for: tripDistanceInMeters)
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
      self.configurePickupAndDropOffTimes(with: route.expectedTravelTime)
      completion(route)
    }
  }

  func configurePickupAndDropOffTimes(with expectedTravelTime: Double) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a"

    pickupTime = dateFormatter.string(from: Date())
    dropOffTime = dateFormatter.string(from: Date() + expectedTravelTime)
  }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    results = completer.results
  }
}
