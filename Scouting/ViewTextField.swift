//
//  ViewTextField.swift
//  InterfaceConstruction
//
//  Created by Alex DeMeo on 1/6/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewTextField: CustomView {
    var label: UILabel!
    var textField: UITextField!
    var type: String!
    
    init(title: String, key: String, type: String) {
        super.init(title: title, key: key)
        self.label = UILabel(frame: CGRect(x: self.frame.minX + 5, y: 0, width: self.frame.width * (1/2), height: self.frame.height))
        self.label.font = UIFont.systemFont(ofSize: CustomView.textSize)
        self.label.text = "\(title)"
        self.addSubview(self.label)
        
        self.textField = UITextField(frame: CGRect(x: self.frame.midX, y: 10, width: self.frame.width * (1/2) - 5, height: self.frame.height * (1/2)))
        self.textField.borderStyle = UITextBorderStyle.bezel
        self.textField.backgroundColor = UIColor.white()
        self.type = type.trim()
        switch self.type {
        case "decimal": self.textField.keyboardType = UIKeyboardType.decimalPad
        case "normal": self.textField.keyboardType = UIKeyboardType.default
        case "number": self.textField.keyboardType = UIKeyboardType.numberPad
        default: break
        }
        self.addSubview(self.textField)
        self.textField.delegate = self
        if key != "" {
            ViewControllerScout.allPotentialKeys.append(key)
            ViewControllerScout.keyToType[key] = "textfield"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.superview!.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == nil {
            return
        }
        KEYS[self.key] = textField.text!
        print("For key: \(self.key), value is: \(textField.text!)")
    }
}
