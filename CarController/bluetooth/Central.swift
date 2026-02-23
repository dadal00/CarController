//
//  BluetoothManager.swift
//  CarController
//
//  Created by Dylan Adal on 2/23/26.
//

import CoreBluetooth

class BluetoothCentral: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var manager: CBCentralManager!
    var carPeripheral: CBPeripheral?
    var throttleCharacteristic: CBCharacteristic?
    var steeringCharacteristic: CBCharacteristic?
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // callback once bluetooth on then scan for peripherals
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // check if bluetooth
        if central.state == .poweredOn {
            print("Bluetooth is ON")
            
            // only look for my relevant uuid
            manager.scanForPeripherals(withServices: [IDs.car])
        }
    }
    
    // found a peripheral, save and connect to it
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print("Found peripheral: \(peripheral.name ?? "Unknown")")
        
        // save and connect to device
        self.carPeripheral = peripheral
        manager.stopScan()
        manager.connect(peripheral)
    }
    
    // connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral")
        
        // once connected, probe for list of actual characteristics
        peripheral.delegate = self
        peripheral.discoverServices([IDs.car])
    }
    
    
    /* Peripherals */
    
    // discover characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics([IDs.throttle, IDs.steering], for: service)
        }
    }
    
    // identify and assign characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for char in characteristics {
            switch char.uuid {
            case IDs.throttle:
                self.throttleCharacteristic = char
                print("Found throttle!")
            case IDs.steering:
                self.steeringCharacteristic = char
                print("Found steering!")
            default:
                print("Unknown characteristic: \(char.uuid)")
            }
        }
    }
    
    func sendCarCommand(value: UInt8, characteristic: CBCharacteristic) {
        if carPeripheral == nil {
            return
        }
        
        // convert to bytes and write
        let valueBytes = withUnsafeBytes(of: value) { Data($0) }
        carPeripheral!.writeValue(valueBytes, for: characteristic, type: .withResponse)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Failed to write to \(characteristic.uuid.uuidString): \(error.localizedDescription)")
        } else {
            print("Successfully wrote to \(characteristic.uuid.uuidString)")
        }
    }
    
    func updateCar(throttle: UInt8, steering: UInt8) {
        if throttleCharacteristic == nil || steeringCharacteristic == nil {
            print("throttle or steering not found!")
            return
        }
        
        sendCarCommand(value: throttle, characteristic: throttleCharacteristic!)
        sendCarCommand(value: steering, characteristic: steeringCharacteristic!)
    }
}
