//
//  ViewLabel.swift
//  InterfaceConstruction
//
//  Created by Alex DeMeo on 1/6/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit

class ViewLabel: CustomView {
    var label: UILabel!
    
    init(title: String, type: String, justification: String) {
        super.init(title: title, key: "")        
        self.label = UILabel(frame: CGRect(x:  self.frame.minX, y: 5, width: self.frame.width, height: self.frame.height * (3/4)))
        self.label.text = title
        self.label.font = UIFont.systemFont(ofSize: CustomView.textSize)
        switch type.trim() {
        case "distinguished":
            var lines = [UIImageView]()
            lines.append(UIImageView(frame: CGRect(x: self.frame.minX, y: 0, width: self.frame.width, height: 5)))
            lines.append(UIImageView(frame: CGRect(x: self.frame.minX, y: CGFloat(CustomView.height - 5), width: self.frame.width, height: 5)))
            for line in lines {
                line.image = UIImage(named: "Line")
                self.addSubview(line)
            }
        case "bold":
            self.label.font = UIFont.boldSystemFont(ofSize: CustomView.textSize)
        case "normal": break
        default: break
        }
        switch justification.trim() {
        case "left":
            self.label.textAlignment = NSTextAlignment.left
        case "center":
            self.label.textAlignment = NSTextAlignment.center
        case "right":
            self.label.textAlignment = NSTextAlignment.right
        default: break
        }
        self.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
