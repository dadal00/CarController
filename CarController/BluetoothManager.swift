//
//  BluetoothManager.swift
//  CarController
//
//  Created by Dylan Adal on 2/23/26.
//

import CoreBluetooth

// nsobject just base class
// observable object used for when we want to track state changes and inject into the visuals
// cbcentral is the central bluetooth manager
// peripheral is needed when we want to connect + write to some device
class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var targetCharacteristic: CBCharacteristic?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // required function to be a manager delegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is ON")
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
}
