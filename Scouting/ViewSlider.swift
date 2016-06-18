//
//  ViewSlider.swift
//  Scouting
//
//  Created by Alex DeMeo on 1/20/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit

class ViewSlider : CustomView {
    
    var slider: UISlider!
    var label: UILabel!
    
    init(lowerBound: Int, upperBound: Int, title: String, key: String) {
        super.init(title: title, key: key)
        self.label = UILabel(frame: CGRect(x: self.frame.minX, y: -12.5, width: self.frame.width, height: self.frame.height))
        self.label.text = title
        self.label.textAlignment = NSTextAlignment.center
        self.label.font = UIFont.systemFont(ofSize: CustomView.textSize - 2)
        self.addSubview(self.label)
        
        self.slider = UISlider(frame: CGRect(x: self.frame.minX + 7.5, y: self.frame.height * (2/5), width: self.frame.width - 15, height: self.frame.height * (4/7)))
        self.slider.minimumValue = Float(lowerBound)
        self.slider.maximumValue = Float(upperBound)
        self.addSubview(self.slider)
        self.slider.addTarget(self, action: #selector(ViewSlider.changed(_:)), for: UIControlEvents.valueChanged)
        ViewControllerScout.allPotentialKeys.append(key)
        ViewControllerScout.keyToType[key] = "slider"
    }
    
    func changed(_ sender: UISlider) {
        print("Value for key: \(key) is: \(sender.value)")
        KEYS[self.key] = "\(sender.value)"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
