//
//  ViewSegmentedControl.swift
//  InterfaceConstruction
//
//  Created by Alex DeMeo on 1/6/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit

class ViewSegCtrl: CustomView {
    var label: UILabel!
    var segCtrl: UISegmentedControl!
    
    init(title: String, key: String, elements: [String]) {
        super.init(title: title, key: key)
        self.label = UILabel(frame: CGRect(x: self.frame.minX, y: -15, width: self.frame.width, height: self.frame.height))
        self.label.text = title
        self.label.textAlignment = NSTextAlignment.center
        self.label.font = UIFont.systemFont(ofSize: CustomView.textSize)
        self.addSubview(self.label)
        
        self.segCtrl = UISegmentedControl(items: elements)
        self.segCtrl.frame = CGRect(x: self.frame.minX + 7.5, y: self.frame.height * (2/5), width: self.frame.width - 15, height: self.frame.height * (4/7))
        self.addSubview(self.segCtrl)
        self.segCtrl.addTarget(self, action: #selector(ViewSegCtrl.changed(_:)), for: UIControlEvents.valueChanged)
        for var el in elements {
//            el.trim()
            el = el.replacingOccurrences(of: "  ", with: " ")
            el = el.replacingOccurrences(of: " ", with: "_")
            el = el.replacingOccurrences(of: "/", with: "_")
            ViewControllerScout.allPotentialKeys.append("\(key)_\(el)")
            ViewControllerScout.keyToType["\(key)_\(el)"] = "segctrl"
        }
    }
    
    func changed(_ segCtrl: UISegmentedControl) {
        KEYS[self.key] = segCtrl.titleForSegment(at: segCtrl.selectedSegmentIndex)!
        print("For key: \(self.key), value is: \(segCtrl.titleForSegment(at: segCtrl.selectedSegmentIndex)!)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewSegCtrl {

}
