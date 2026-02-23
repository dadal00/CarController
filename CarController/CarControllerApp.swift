//
//  CarControllerApp.swift
//  CarController
//
//  Created by Dylan Adal on 2/18/26.
//

import SwiftUI

@main
struct CarControllerApp: App {
    // state object is used when we want to track changes and show them in the visuals
    @StateObject var bluetoothManager = BluetoothManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
