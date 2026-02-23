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
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            let throttle = CBMutableCharacteristic(type: IDs.throttle,
                                                   properties: [.write],
                                                   value: nil,
                                                   permissions: [.writeable])
            let steering = CBMutableCharacteristic(type: IDs.steering,
                                                   properties: [.write],
                                                   value: nil,
                                                   permissions: [.writeable])
            
            let service = CBMutableService(type: IDs.car, primary: true)
            service.characteristics = [throttle, steering]
            peripheralManager.add(service)
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [IDs.car]])
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager,
                           didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            guard let value = request.value else { continue }

            if request.characteristic.uuid == IDs.throttle {
                let throttleValue = value.first
                print("Received throttle value: \(String(describing: throttleValue))")
                
            } else if request.characteristic.uuid == IDs.steering {
                let steeringValue = value.first
                print("Received steering value: \(String(describing: steeringValue))")
            }

            // Respond to the central to confirm write
            peripheralManager.respond(to: request, withResult: .success)
        }
    }
}
