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
  @Published var selectedLocationCoordinate: CLLocationCoordinate2D?

  private let searchCompleter = MKLocalSearchCompleter()

  var queryFragment: String = "" {
    didSet {
      searchCompleter.queryFragment = queryFragment
    }
  }

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
      self.selectedLocationCoordinate = coordinate

      print("DEBUG: Selected location coordinates \(coordinate)")
    }
  }

  func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)

    let search = MKLocalSearch(request: searchRequest)
    search.start(completionHandler: completion)
  }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    results = completer.results
  }
}
