//
//  QRCodableApp.swift
//  QRCodable
//
//  Created by Giorgos Charitakis on 1/11/25.
//

import SwiftUI

@main
struct QRCodableApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
        }
        .windowResizability(.contentSize)
    }
}
