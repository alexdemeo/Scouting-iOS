//
//  ViewControllerRequest.swift
//  Scouting
//
//  Created by Alex DeMeo on 2/22/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewControllerRequest: UIViewController, UITextFieldDelegate {
    internal static var instance: ViewControllerRequest!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    
    var currentTextFieldIndex = -1
    var gestureCloseKeyboard: UITapGestureRecognizer!
    var requestTeamsStr = "raw;;key;;sign;;value"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingSpinner.isHidden = true
        for textField in textFields {
            textField.delegate = self
        }
        textFields[0].keyboardType = UIKeyboardType.numberPad
        textFields[4].keyboardType = UIKeyboardType.decimalPad
        
        self.gestureCloseKeyboard = UITapGestureRecognizer(target: self, action: #selector(ViewControllerRequest.closeKeyboard(_:)))
        self.view.addGestureRecognizer(self.gestureCloseKeyboard)
        for key in ViewControllerScout.allPotentialKeys {
            print("HAS KEY: \(key)")
            let pkey = self.toPrettyKey(key)
            ViewControllerScout.prettyToKey[pkey] = key
            ViewControllerScout.allPrettyKeys.append(pkey)
        }
    }
    
    private func toPrettyKey(_ key: String) -> String {
        var pts = key.components(separatedBy: "_")
        pts[0] = pts[0].uppercased()
        for i in 1..<pts.count {
            pts[i] = pts[i].capitalized
        }
        var f = ""
        for pt in pts {
            f += " \(pt)"
        }
        return f
    }
    
    func showInfoWithStringData(_ data: String) {
        self.loadingSpinner.stopAnimating()
        self.loadingSpinner.isHidden = true
        
    }
    
    func showSummaryWithStringData(_ data: String) {
        self.loadingSpinner.stopAnimating()
        self.loadingSpinner.isHidden = true
        let teamDict = NSMutableDictionary()
        do {
            let regex = try RegularExpression(pattern: "\\[(.*?)\\]", options: RegularExpression.Options.allowCommentsAndWhitespace)
            
            let parts = regex.matches(in: data, options: RegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, data.characters.count))
            
            let pieces: [String] = parts.map({
                result in
                (data as NSString).substring(with: result.range)
            })
            for var p in pieces {
                p.remove("[")
                p.remove("]")
                let s = p.components(separatedBy: "=")
                teamDict[s[0]] = s[1]
            }
            ViewControllerData.reinstantiate(teamDict)
            self.present(ViewControllerData.instance, animated: true, completion: {})
        } catch {
            print("Eror parsing data: \(error)")
            alert("Could not read the data the computer sent")
        }
    }

    
    @IBAction func btnSearchTeamPressed(_ sender: UIButton) {
        self.loadingSpinner.isHidden = false
        self.loadingSpinner.startAnimating()
        let teamNum = textFields[0].text!
        let requestStr = "n::\(teamNum)"
        print("TEAM string: \(requestStr)")
        ViewControllerMain.instance.peripheralManager.updateValue(requestStr.data(using: String.Encoding.utf8)!, for: CHARACTERISTIC_DB, onSubscribedCentrals: nil)
        
    }
    
    @IBAction func btnSearchInfoPressed(_ sender: UIButton) {
        let p1 = textFields[1].text == "Average" ? "avg" : "raw"
        let p2 = ViewControllerScout.prettyToKey[textFields[2].text!]!
        let p3 = textFields[3].text!
        let p4 = textFields[4].text!
        let teamsInfo = "\(p1);;\(p2);;\(p3);;\(p4)"
        let requestStr = "i::\(teamsInfo)"
        print("INFO string: \(requestStr)")
        ViewControllerMain.instance.peripheralManager.updateValue(requestStr.data(using: String.Encoding.utf8)!, for: CHARACTERISTIC_DB, onSubscribedCentrals: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case textFields[0]:
            self.currentTextFieldIndex = 0
        case textFields[1]:
            self.currentTextFieldIndex = 1
            self.getPickerChoice(["Raw value", "Average"], title: "Which type of data to look at?", completion: {
                val in
                self.textFields[1].text = val
            })
        case textFields[2]:
            self.currentTextFieldIndex = 2
            self.getPickerChoice(ViewControllerScout.allPrettyKeys, title: "Select key", completion: {
                val in
                self.textFields[2].text = val
            })
        case textFields[3]:
            self.currentTextFieldIndex = 3
            self.getPickerChoice([">", "<", "≥", "≤", "="], title: "Select the operator for comparison", completion: {
                val in
                self.textFields[3].text = val
            })
        case textFields[4]:
            self.currentTextFieldIndex = 4
        default:
            self.currentTextFieldIndex = -1
        }
    }
    
    @IBAction func btnGoBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentTextFieldIndex = -1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func closeKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func getPickerChoice(_ items: [String], title: String, completion: (String) -> ()) {
        self.view.endEditing(true)
        let pickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Picker") as! ViewControllerPicker
        self.present(pickerVC, animated: true, completion: {
            pickerVC.initialize(items: items, title: title, completion: {
                completion(pickerVC.retValue!)
            })
        })
    }
    
    func reinstantiate() {
        ViewControllerRequest.instance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Request") as! ViewControllerRequest
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
