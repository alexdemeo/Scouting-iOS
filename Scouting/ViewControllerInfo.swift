//
//  ViewControllerInfo.swift
//  Scouting
//
//  Created by Alex DeMeo on 1/29/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit

class ViewControllerInfo : UIViewController {
    @IBOutlet var textView: UITextView!
    
    internal static var instance: ViewControllerInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded Info View Controller")
        self.textView.isUserInteractionEnabled = true
        self.textView.isScrollEnabled = true        
        self.textView.frame = CGRect(x: self.textView.frame.origin.x, y: self.textView.frame.origin.y, width: self.textView.frame.width, height: UIScreen.main().bounds.height * (2/3))
        self.textView.frame.origin.x = (self.view.frame.width / 2) - (self.textView.frame.width / 2)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
