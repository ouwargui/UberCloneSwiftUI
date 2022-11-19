//
//  UberSwiftUICloneApp.swift
//  UberSwiftUIClone
//
//  Created by Guilherme Santos on 18/11/22.
//

import SwiftUI

@main
struct UberSwiftUICloneApp: App {
  @StateObject var locationViewModel = LocationSearchViewModel()
  
  var body: some Scene {
    WindowGroup {
      HomeView()
        .environmentObject(locationViewModel)
    }
  }
}
