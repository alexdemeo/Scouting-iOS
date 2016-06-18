//
//  Util.swift
//  Scouting
//
//  Created by Alex DeMeo on 1/8/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit

var KEYS: NSMutableDictionary = NSMutableDictionary()

extension String {
    mutating func remove(_ str: String) {
        if self.contains(str) {
            let range = self.range(of: str)
            self.removeSubrange(range!)
            self = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    mutating func cleanupArgs() -> [String] {
        self.remove(at: self.startIndex)
        self.remove(at: self.index(before: self.endIndex))
        return self.components(separatedBy: ",")
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

func topMostViewController() -> UIViewController {
    var topCtrller = UIApplication.shared().keyWindow!.rootViewController
    while topCtrller!.presentedViewController != nil {
        topCtrller = topCtrller!.presentedViewController
    }
    return topCtrller!
}

func alert(_ message: String) {
    let alert = UIAlertController(title: "Scouting", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {
        action -> () in
    }))
    topMostViewController().present(alert, animated: true, completion: {
        () -> () in
        print("Alerting: \(message)")
    })
}

func alert(_ message: String, timeout: TimeInterval) {
    let alert = UIAlertController(title: "Scouting", message: message, preferredStyle: UIAlertControllerStyle.alert)
    topMostViewController().present(alert, animated: true, completion: {
        () -> () in
        print("Alerting: \(message)")
        Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: {
            alert.dismiss(animated: true, completion: nil)
        })
    })
}

func alert(_ message: String, completion: () -> ()) {
    let alert = UIAlertController(title: "Scouting", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: {
        action -> () in
        completion()
    }))
    topMostViewController().present(alert, animated: true, completion: {
        print("Alerting: \(message)")
    })
}

extension UIView {
    func startRotating(_ duration: Double) {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = -Float(M_PI * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
