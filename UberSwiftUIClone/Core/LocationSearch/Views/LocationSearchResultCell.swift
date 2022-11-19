//
//  LocationSearchResultCell.swift
//  UberSwiftUIClone
//
//  Created by Guilherme Santos on 18/11/22.
//

import SwiftUI

struct LocationSearchResultCell: View {
  let title: String
  let subtitle: String

  var body: some View {
    HStack {
      Image(systemName: "mappin.circle.fill")
        .resizable()
        .foregroundColor(.blue)
        .tint(.white)
        .frame(width: 40, height: 40)

      VStack(alignment: .leading, spacing: 2) {
        Text(title)
          .font(.body)

        Text(subtitle)
          .font(.system(size: 15))
          .foregroundColor(.gray)

        Divider()
      }
      .padding(.leading, 8)
      .padding(.vertical, 8)
    }
    .padding(.horizontal)
  }
}
