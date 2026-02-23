//
//  Constants.swift
//  CarController
//
//  Created by Dylan Adal on 2/23/26.
//

import CoreBluetooth

enum IDs {
    // uuids must be hex, 4 byte or 16 byte
    static let car          = CBUUID(string: "AAAA")
    static let throttle     = CBUUID(string: "BBBB")
    static let steering     = CBUUID(string: "CCCC")
}
