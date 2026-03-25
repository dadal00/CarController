import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothCentral: BluetoothCentral
    
    var body: some View {
        // center everything
        VStack {
            // center vertically
            Spacer()
            Button(action: {
                bluetoothCentral.updateCar(throttle: 1, steering: 1)
            }) {
                Text("Press Me")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            // center vertically
            Spacer()
        }
        // full width
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // light background
        .background(Color.gray.opacity(0.1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bluetoothCentral: BluetoothCentral())
    }
}
