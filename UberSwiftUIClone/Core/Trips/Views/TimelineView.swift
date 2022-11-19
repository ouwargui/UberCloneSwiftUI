//
//  TimelineView.swift
//  UberSwiftUIClone
//
//  Created by Guilherme Santos on 19/11/22.
//

import SwiftUI

struct TimelineView: View {
  let isLarge: Bool

  var body: some View {
    VStack {
      Circle()
        .fill(Color(.systemGray3))
        .frame(width: isLarge ? 8 : 6, height: isLarge ? 8 : 6)
      Rectangle()
        .fill(Color(.systemGray3))
        .frame(width: 1, height: isLarge ? 32 : 24)
      Rectangle()
        .fill(.black)
        .frame(width: isLarge ? 8 : 6, height: isLarge ? 8 : 6)
    }
  }
}

struct TimelineView_Previews: PreviewProvider {
  static var previews: some View {
    TimelineView(isLarge: true)
  }
}
