//
//  Color.swift
//  UberSwiftUIClone
//
//  Created by Guilherme Santos on 21/11/22.
//

import SwiftUI

extension Color {
  static let theme = ColorTheme()
}

struct ColorTheme {
  let backgroundColor = Color("BackgroundColor")
  let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
  let primaryTextColor = Color("PrimaryTextColor")
}
