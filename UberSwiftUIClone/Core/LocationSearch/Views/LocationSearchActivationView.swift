//
//  LocationSearchActivationView.swift
//  UberSwiftUIClone
//
//  Created by Guilherme Santos on 18/11/22.
//

import SwiftUI

struct LocationSearchActivationView: View {
  var body: some View {
    HStack {
      Rectangle()
        .fill(.black)
        .frame(width: 8, height: 8)
        .padding(.horizontal)

      Text("Where to?")
        .foregroundColor(Color(.darkGray))

      Spacer()
    }
    .frame(width: UIScreen.main.bounds.width - 64, height: 50)
    .background(
      Rectangle()
        .fill(.white)
        .shadow(color: .black, radius: 6)
    )
  }
}
