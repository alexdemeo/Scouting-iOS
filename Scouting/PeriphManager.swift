//
//  Periph.swift
//  Scouting
//
//  Created by Alex DeMeo on 1/8/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import CoreBluetooth
import UIKit

/**
 Bluetooth peripheral manager class. See apple documentation for method info
 */
private var dataStr = ""
extension ViewControllerMain: CBPeripheralManagerDelegate {
    
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: NSError?) {
        print("Started advertising")
    }
    
    func resetPeriphManager() {
        self.theService = CBMutableService(type: UUID_SERVICE, primary: true)
        self.theService.characteristics = [CHARACTERISTIC_ROBOT, CHARACTERISTIC_DB]
        self.peripheralManager.add(theService)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if #available(iOS 10.0, *) {
            if peripheral.state == CBManagerState.poweredOn {
                print("Manager powered on")
                self.resetPeriphManager()
            }
        } else {
            print("update state, not iOS 10")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: NSError?) {
        if error != nil {
            print("error: \(error)")
        } else {
            self.peripheralManager.startAdvertising(self.advertisementData)
            print("advertising UUID(passkey)")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Central subscribed to characteristic. Max bytes allowed = \(central.maximumUpdateValueLength)")
        self.btnRefresh.isEnabled = false
        self.sendDataIndex = 0
        self.connectedAndSubscribed = true
        self.lblConnectionStatus.text = "Connected!"
        self.lblConnectionStatus.textColor = UIColor.green()
        self.peripheralManager.stopAdvertising()
        ViewControllerScout.instance.setDefaults()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Central unsubscribed from characteristic")
        self.connectedAndSubscribed = false
        self.lblConnectionStatus.text = "No connection"
        self.btnRefresh.isEnabled = true
        self.lblConnectionStatus.textColor = UIColor.red()
        print("will start advertising with PASSKEY: \(self.passkey)")
        self.peripheralManager.startAdvertising(self.advertisementData)
        switch topMostViewController() {
        case ViewControllerScout.instance:
            alert("Lost connection to computer")
            break
        case ViewControllerData.instance:
            alert("Lost connection to computer")
            break
        default:
            break
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("received read request \(request)")
        peripheral.respond(to: request, withResult: CBATTError.success)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            peripheral.respond(to: request, withResult: CBATTError.success)
            let rStr = NSString(data: request.value!, encoding: String.Encoding.utf8.rawValue)!
            switch rStr {
            case "EOM+TEAM":
                ViewControllerRequest.instance.showSummaryWithStringData(dataStr)
                dataStr = ""
            case "EOM+INFO":
                ViewControllerRequest.instance.showInfoWithStringData(dataStr)
                dataStr = ""
            case "NoReadTable":
                ViewControllerRequest.instance.loadingSpinner.stopAnimating()
                alert("The computer was unable to read the table")
            case "NoReadTeam":
                ViewControllerRequest.instance.loadingSpinner.stopAnimating()
                alert("That team could not be found on the computer's database")
            case "NoReadInfo":
                ViewControllerRequest.instance.loadingSpinner.stopAnimating()
                alert("The computer couldn't search for that information")
            default:
                dataStr += rStr as String
            }
        }
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        self.send()
    }
}
