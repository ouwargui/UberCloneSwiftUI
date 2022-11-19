//
//  LocationSearchView.swift
//  UberSwiftUIClone
//
//  Created by Guilherme Santos on 18/11/22.
//

import SwiftUI

struct LocationSearchView: View {
  @State private var startLocationText = ""
  @Binding var mapState: MapViewState
  @EnvironmentObject var viewModel: LocationSearchViewModel

  var body: some View {
    VStack(spacing: 0) {
      // header view
      HStack {
        TimelineView(isLarge: false)

        VStack {
          TextField("Current location", text: $startLocationText)
            .frame(height: 32)
            .background(Color(.systemGroupedBackground))
            .padding(.trailing)

          TextField("Where to?", text: $viewModel.queryFragment)
            .frame(height: 32)
            .background(Color(.systemGray4))
            .padding(.trailing)
        }
      }
      .padding(.horizontal)
      .padding(.top, 64)

      Divider()
        .padding(.top)

      // list view
      ScrollView {
        VStack(alignment: .leading) {
          ForEach(viewModel.results, id: \.self) { result in
            LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
              .onTapGesture {
                withAnimation(.spring()) {
                  viewModel.selectLocation(result)
                  mapState = .locationSelected
                }
              }
          }
        }
        .padding(.top)
      }
    }
    .background(.white)
  }
}

/* struct LocationSearchView_Previews: PreviewProvider {
   static var previews: some View {
     LocationSearchView(startLocationText: <#T##arg#>, mapState: <#T##MapViewState#>, viewModel: <#T##LocationSearchViewModel#>)
   }
 }
 */
