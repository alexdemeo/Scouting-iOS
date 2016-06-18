//
//  BluetoothUtil.swift
//  Scouting
//
//  Created by Alex DeMeo on 1/8/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import CoreBluetooth
import UIKit


public var UUID_SERVICE: CBUUID = CBUUID(string: "333B")
public let UUID_CHARACTERISTIC_ROBOT: CBUUID = CBUUID(string: "20D0C428-B763-4016-8AC6-4B4B3A6865D9")
public let UUID_CHARACTERISTIC_DB: CBUUID = CBUUID(string: "80A37B7F-0563-409B-B320-8C1768CE6A58")
public let NOTIFY_MTU: NSInteger = 75

var sendBackData: Data!

public let CHARACTERISTIC_ROBOT = CBMutableCharacteristic(type: UUID_CHARACTERISTIC_ROBOT, properties: CBCharacteristicProperties.notify, value: ViewControllerMain.instance.dataToSend?.base64EncodedData(), permissions: CBAttributePermissions.readable)
public let CHARACTERISTIC_DB  = CBMutableCharacteristic(type: UUID_CHARACTERISTIC_DB, properties: CBCharacteristicProperties(rawValue: CBCharacteristicProperties.notify.rawValue | CBCharacteristicProperties.write.rawValue), value: sendBackData, permissions: CBAttributePermissions.writeable)

let K_TEAM_NUMBER = "team_num"
let K_MATCH_NUMBER = "match_num"
let K_TEAM_COLOR = "team_color"

func isValidID(_ id: String) -> Bool {
    let lwr = id.lowercased()
    func isInt(_ char: Character) -> Bool {
        for i in 0...9 {
            if String(char) == "\(i)" {
                return true
            }
        }
        return false
    }
    
    if lwr.characters.count != 4 {
        return false
    } else {
        for char: Character in lwr.characters {
            if !isInt(char) {
                if  char != "a" &&
                    char != "b" &&
                    char != "c" &&
                    char != "d" &&
                    char != "e" &&
                    char != "f" {
                        return false
                }
            }
        }
    }
    return true;
}
