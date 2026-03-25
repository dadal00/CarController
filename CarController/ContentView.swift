import UIKit

extension UIDevice {
    var isLandscape: Bool {
        orientation == .landscapeLeft || orientation == .landscapeRight
    }
}

import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothCentral: BluetoothCentral
    
    @State private var throttle: UInt8 = 0
    @State private var steering: UInt8 = 0
    
    var body: some View {
        HStack {
            JoystickView(axis: .vertical, value: $throttle).frame(maxWidth: .infinity)
            
            Text(bluetoothCentral.carPeripheral != nil ? "Connected" : "Disconnected")
                .foregroundColor(.white)
                .padding(8)
                .background(bluetoothCentral.carPeripheral != nil ? Color.green : Color.red)
                .cornerRadius(8)
            
            JoystickView(axis: .horizontal, value: $steering).frame(maxWidth: .infinity)
        }
        .padding()
        .onChange(of: throttle) { t in
            print("Throttle changed: \(t)")
            bluetoothCentral.updateCar(throttle: t, steering: steering)
        }
        .onChange(of: steering) { s in
            print("Steering changed: \(s)")
            bluetoothCentral.updateCar(throttle: throttle, steering: s)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bluetoothCentral: BluetoothCentral())
    }
}
