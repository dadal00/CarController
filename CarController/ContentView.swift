import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothCentral: BluetoothCentral
    @ObservedObject var bluetoothPeripheral: BluetoothPeripheral
    @State private var isBluetoothManager: Bool = true
    
    var body: some View {
        // Center everything
        VStack {
            Spacer() // Push content to center vertically
            
            Toggle("Is Bluetooth Manager", isOn: $isBluetoothManager)
                            .padding()
            
            Button(action: {
                if isBluetoothManager {
                    bluetoothCentral.updateCar(throttle: 1, steering: 1)
                } else {
                    print("Button pressed!")
                }
            }) {
                Text("Press Me")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer() // Push content to center vertically
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Take full screen
        .background(Color.gray.opacity(0.1)) // Optional: light background
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bluetoothCentral: BluetoothCentral(), bluetoothPeripheral: BluetoothPeripheral())
    }
}
