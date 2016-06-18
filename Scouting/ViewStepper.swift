//
//  ViewStepper.swift
//  InterfaceConstruction
//
//  Created by Alex DeMeo on 1/6/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit

class ViewStepper: CustomView {
    var label: UILabel!
    var stepper: UIStepper!
    
    init(title: String, key: String, lowerBound: Int, upperBound: Int) {
        super.init(title: title, key: key)
        self.stepper = UIStepper(frame: CGRect(x: self.frame.maxX - 105, y: 5, width: 100, height: self.frame.height * (1/2)))
        self.stepper.minimumValue = Double(lowerBound)
        self.stepper.maximumValue = Double(upperBound)
        self.addSubview(self.stepper)

        self.label = UILabel(frame: CGRect(x: self.frame.minX + 5, y: 5, width: self.frame.width * (1/2), height: self.frame.height))
        self.label.font = UIFont.systemFont(ofSize: CustomView.textSize - 3)
        self.label.text = "\(title): \(Int(stepper.value))"
        self.addSubview(self.label)
        
        self.stepper.addTarget(self, action: #selector(ViewStepper.changed(_:)), for: UIControlEvents.valueChanged)
        ViewControllerScout.allPotentialKeys.append(key)
        ViewControllerScout.keyToType[key] = "stepper"
    }
    
    func changed(_ stepper: UIStepper) {
        KEYS[self.key] = Int(stepper.value)
        self.label.text = "\(title): \(Int(stepper.value))"
        print("For key: \(self.key), value is: \(Int(stepper.value))")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

