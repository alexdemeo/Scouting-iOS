//
//  CustomView.swift
//  InterfaceConstruction
//
//  Created by Alex DeMeo on 1/6/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit

class CustomView: UIView {
    internal static var height = 50;
    internal static let textSize: CGFloat = 16
    internal static var nextAvailableY: Int = 0
    internal static var colorRedForView = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
    internal static var colorBlueForView = UIColor(red: 0, green: 0, blue: 1, alpha: 0.1)

    
    var title: String
    var key: String
    var prettyKey: String!
    
    init(title: String, key: String) {
        self.title = title
        self.key = key
        super.init(frame: CGRect(x: Int(ViewControllerMain.instance.view.frame.minX), y: CustomView.nextAvailableY, width: Int(ViewControllerMain.instance.view.frame.width), height: CustomView.height))
        CustomView.nextAvailableY += CustomView.height
        self.backgroundColor = CustomView.colorBlueForView
    }
    
    func add() {
        ViewControllerScout.instance.scrollView.addSubview(self)
    }
    
    class func getAllViews() -> [CustomView] {
        var views = [CustomView]()
        for switchView in ViewControllerScout.arraySwitchViews {
            views.append(switchView)
        }
        for lblView in ViewControllerScout.arrayLabelViews {
            views.append(lblView)
        }
        for segCtrView in ViewControllerScout.arraySegCtrlViews {
            views.append(segCtrView)
        }
        for txtFieldView in ViewControllerScout.arrayTextFieldViews {
            views.append(txtFieldView)
        }
        for sliderView in ViewControllerScout.arraySliderViews {
            views.append(sliderView)
        }
        for stepperView in ViewControllerScout.arrayStepperViews {
            views.append(stepperView)
        }
        return views
    }
    
    internal class func prettyKey(_ key: String) -> String {
        var parts = key.components(separatedBy: "_")
        parts[0] = parts[0].uppercased()
        for i in 1..<parts.count {
            parts[i] = parts[i].uppercased()
        }
        var f = ""
        for pt in parts {
            f += " \(pt.trim())"
        }
        return f
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
