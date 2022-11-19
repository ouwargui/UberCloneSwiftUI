//
//  HomeView.swift
//  UberSwiftUIClone
//
//  Created by Guilherme Santos on 18/11/22.
//

import SwiftUI

struct HomeView: View {
  @State private var mapState = MapViewState.noInput

  var body: some View {
    ZStack(alignment: .top) {
      UberMapViewRepresentable()
        .ignoresSafeArea()

      if mapState == .searchingForLocation {
        LocationSearchView(mapState: $mapState)
      } else if mapState == .noInput {
        LocationSearchActivationView()
          .padding(.top, 72)
          .onTapGesture {
            withAnimation(.spring()) {
              mapState = .searchingForLocation
            }
          }
      }

      MapViewActionButton(mapState: $mapState)
        .padding(.leading)
        .padding(.top, 4)
    }
  }
}
