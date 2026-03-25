//
//  Peripheral.swift
//  CarController
//
//  Created by Dylan Adal on 2/23/26.
//

import CoreBluetooth

class BluetoothPeripheral: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager!
    
    override init() {
        super.init()
        
        if !isPeripheral {
            return
        }
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        print("Initializing peripheral...")
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            let control = CBMutableCharacteristic(type: IDs.control,
                                                  properties: [.write],
                                                  value: nil,
                                                  permissions: [.writeable])
            
            let service = CBMutableService(type: IDs.car, primary: true)
            service.characteristics = [control]
            peripheralManager.add(service)
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [IDs.car]])
            
            print("Initialized.")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager,
                           didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            guard let value = request.value else { continue }
            let bytes = [UInt8](value)
            
            if request.characteristic.uuid == IDs.control && bytes.count >= 2 {
                print("Throttle: \(bytes[0]), Steering: \(bytes[1])")
            } else {
                print("Received unknown value: \(String(describing: value.first))")
            }
            
            // Respond to the central to confirm write
            peripheralManager.respond(to: request, withResult: .success)
        }
    }
}
