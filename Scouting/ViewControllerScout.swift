//
//  ViewControllerScout.swift
//  Scouting
//
//  Created by Alex DeMeo on 2/18/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit

class ViewControllerScout: UIViewController {
    @IBOutlet var txtTeamNum: UITextField!
    @IBOutlet var txtMatchNum: UITextField!
    @IBOutlet var segTeamColor: UISegmentedControl!
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    var gestureCloseKeyboard: UITapGestureRecognizer!
    
    internal static var instance: ViewControllerScout!
    
    internal static var arrayStepperViews: [ViewStepper] = [ViewStepper]()
    internal static var arrayTextFieldViews: [ViewTextField] = [ViewTextField]()
    internal static var arraySegCtrlViews: [ViewSegCtrl] = [ViewSegCtrl]()
    internal static var arrayLabelViews: [ViewLabel] = [ViewLabel]()
    internal static var arraySwitchViews: [ViewSwitch] = [ViewSwitch]()
    internal static var arraySliderViews: [ViewSlider] = [ViewSlider]()
    internal static var arraySpaceViews: [CustomView] = [CustomView]()
    internal static var arrayAllViews: [CustomView] = [CustomView]()
    
    internal static var prettyToKey: [String : String] = [String : String]()
    internal static var keyToType: [String : String] = [String : String]() //types are switch, segctrl, stepper, textfield, slider
    internal static var allPotentialKeys: [String] = [String]()
    internal static var allPrettyKeys: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Scout VC appeared")
        self.gestureCloseKeyboard = UITapGestureRecognizer(target: self, action: #selector(ViewControllerScout.closeKeyboard(_:)))
        self.scrollView.addGestureRecognizer(self.gestureCloseKeyboard)
        self.scrollView.contentSize.height = CGFloat(FileUtil.fileContentsTrimmed.count * CustomView.height) + (self.btnDone.frame.height * 3) + self.segTeamColor.frame.origin.y + 5
        
        self.btnDone.frame = CGRect(x: self.btnDone.frame.origin.x, y: self.scrollView.contentSize.height - self.btnDone.frame.height - 5, width: self.btnDone.frame.width, height: self.btnDone.frame.height)
        self.btnDone.addTarget(ViewControllerMain.instance, action: #selector(ViewControllerMain.instance.sendData(_:)), for: UIControlEvents.touchDown)
        self.txtTeamNum.keyboardType = UIKeyboardType.numberPad
        self.txtMatchNum.keyboardType = UIKeyboardType.numberPad
        self.txtTeamNum.delegate = self
        self.txtMatchNum.delegate = self
        self.segTeamColor.addTarget(self, action: #selector(self.segTeamColorChanged(_:)), for: UIControlEvents.valueChanged)
        self.segTeamColor.selectedSegmentIndex = 0
        for view in ViewControllerScout.arrayAllViews {
            view.add()
        }
        self.scrollView.backgroundColor = CustomView.colorBlueForView
        self.setColor(UIColor.blue())
    }
    
    func initialize() {
        print("Initializing Scout View Controller")
        CustomView.nextAvailableY = Int(ViewControllerMain.instance.btnRefresh.frame.origin.y + 25)
        for var line in FileUtil.fileContentsTrimmed {
            if line.hasPrefix("SEGMENTED_CONTROL") {
                line.remove("SEGMENTED_CONTROL")
                var parts = line.components(separatedBy: ";;")
                if parts.count != 3 {
                    self.failedToBuildInterface("Malformed text file in a SEGMENTED_CONTROL")
                    return
                }
                
                var elements = parts[0].cleanupArgs()
                for i in 0..<elements.count {
                    elements[i] = elements[i].trim()
                }
                let s = ViewSegCtrl(title: parts[1].trim(), key: parts[2].trim(), elements: elements)
                ViewControllerScout.arraySegCtrlViews.append(s)
                ViewControllerScout.arrayAllViews.append(s)
            } else if line.hasPrefix("TEXTFIELD") {
                line.remove("TEXTFIELD")
                var parts = line.components(separatedBy: ";;")
                if parts.count != 3 {
                    self.failedToBuildInterface("Malformed text file in a TEXTFIELD")
                    return
                }
                let args = parts[0].cleanupArgs()
                if args.count != 1 {
                    self.failedToBuildInterface("Malformed TEXTFIELD arguments")
                    return
                }
                let t = ViewTextField(title: parts[1].trim(), key: parts[2].trim(), type: args[0])
                ViewControllerScout.arrayTextFieldViews.append(t)
                ViewControllerScout.arrayAllViews.append(t)
            } else if line.hasPrefix("STEPPER") {
                line.remove("STEPPER")
                var parts = line.components(separatedBy: ";;")
                if parts.count != 3 {
                    self.failedToBuildInterface("Malformed text file in STEPPER")
                    return
                }
                let args = parts[0].cleanupArgs()
                if args.count != 2 {
                    self.failedToBuildInterface("Malformed STEPPER arguments")
                    return
                }
                let s = ViewStepper(title: parts[1].trim(), key: parts[2].trim(), lowerBound: Int(args[0])!, upperBound: Int(args[1])!)
                ViewControllerScout.arrayStepperViews.append(s)
                ViewControllerScout.arrayAllViews.append(s)
            } else if line.hasPrefix("LABEL") {
                line.remove("LABEL")
                var parts = line.components(separatedBy: ";;")
                if parts.count != 2 {
                    self.failedToBuildInterface("Malformed text file in LABEL")
                    return
                }
                let args = parts[0].cleanupArgs()
                if args.count != 2 {
                    self.failedToBuildInterface("Malformed LABEL arguments")
                    return
                }
                let l = ViewLabel(title: parts[1].trim(), type: args[0], justification: args[1])
                ViewControllerScout.arrayLabelViews.append(l)
                ViewControllerScout.arrayAllViews.append(l)
            } else if line.hasPrefix("SWITCH") {
                line.remove("SWITCH")
                var parts = line.components(separatedBy: ";;")
                if parts.count != 3 {
                    self.failedToBuildInterface("Malformed text file in SWITCH")
                    return
                }
                let argTitles = parts[1].components(separatedBy: ",")
                let argKeys = parts[2].components(separatedBy: ",")
                if argTitles.count != argKeys.count {
                    self.failedToBuildInterface("Number of keys and titles for SWITCH do not match up")
                    return
                }
                if argTitles.count > 6 || argKeys.count > 6 {
                    self.failedToBuildInterface("Too many switches, cancelling switch view creation")
                    return
                }
                let s = ViewSwitch(title: "", keys: argKeys, switchTitles: argTitles)
                ViewControllerScout.arraySwitchViews.append(s)
                ViewControllerScout.arrayAllViews.append(s)
            } else if line.hasPrefix("SLIDER") {
                line.remove("SLIDER")
                var parts = line.components(separatedBy: ";;")
                if parts.count != 3 {
                    self.failedToBuildInterface("Malformed text file in SLIDER")
                    return
                }
                let args = parts[0].cleanupArgs()
                if args.count != 2 {
                    self.failedToBuildInterface("Malformed text file in SLIDER arguments")
                    return
                }
                let s = ViewSlider(lowerBound: Int(args[0])!, upperBound: Int(args[1])!, title: parts[1].trim(), key: parts[2].trim())
                ViewControllerScout.arraySliderViews.append(s)
                ViewControllerScout.arrayAllViews.append(s)
            } else if line.hasPrefix("SPACE"){
                let s = CustomView(title: "", key: "")
                ViewControllerScout.arraySpaceViews.append(s)
                ViewControllerScout.arrayAllViews.append(s)
            }
        }
        ViewControllerScout.allPotentialKeys.sortAlphabetically()
    }
    
    func failedToBuildInterface(_ error: String) {
        print(error)
        ViewControllerMain.instance.btnRefresh.isEnabled = false
        self.segTeamColor.isEnabled = false
        self.txtMatchNum.isEnabled = false
        self.txtTeamNum.isEnabled = false
        ViewControllerMain.instance.txtPasskey.isEnabled = false
        for segCtrlView in ViewControllerScout.arraySegCtrlViews {
            segCtrlView.segCtrl.isEnabled = false
        }
        for stepperView in ViewControllerScout.arrayStepperViews {
            stepperView.stepper.isEnabled = false
        }
        for switchView in ViewControllerScout.arraySwitchViews {
            for sw in switchView.switches {
                sw.isEnabled = false
            }
        }
        for textFieldView in ViewControllerScout.arrayTextFieldViews {
            textFieldView.textField.isEnabled = false
        }
        for sliderView in ViewControllerScout.arraySliderViews {
            sliderView.slider.isEnabled = false
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {
            alert(error)
        })
    }
    
    func setColor(_ color: UIColor) {
        self.segTeamColor.tintColor = color
        for stepperView in ViewControllerScout.arrayStepperViews {
            stepperView.stepper.tintColor = color
        }
        for segCtrlView in ViewControllerScout.arraySegCtrlViews {
            segCtrlView.segCtrl.tintColor = color
        }
        for switchView in ViewControllerScout.arraySwitchViews {
            for sw in switchView.switches {
                sw.tintColor = color
            }
        }
        for sliderView in ViewControllerScout.arraySliderViews {
            sliderView.slider.tintColor = color
        }
    }
    
    func setDefaults() {
        print("Reseting default values")
        for segCtrlView in ViewControllerScout.arraySegCtrlViews {
            segCtrlView.segCtrl.selectedSegmentIndex = 0
            KEYS[segCtrlView.key] = segCtrlView.segCtrl.titleForSegment(at: 0) == nil ? "None" : segCtrlView.segCtrl.titleForSegment(at: 0)!
        }
        for textFieldView in ViewControllerScout.arrayTextFieldViews {
            switch textFieldView.type {
            case "decimal":
                KEYS[textFieldView.key] = "0.0"
            case "normal":
                KEYS[textFieldView.key] = ""
            case "number":
                KEYS[textFieldView.key] = "0"
            default: break
            }
            textFieldView.textField.text = ""
        }
        for stepperView in ViewControllerScout.arrayStepperViews {
            stepperView.stepper.value = 0
            stepperView.changed(stepperView.stepper)
            KEYS[stepperView.key] = Int(stepperView.stepper.value)
        }
        for switchView in ViewControllerScout.arraySwitchViews {
            for (index, sw) in switchView.switches.enumerated() {
                sw.isOn = false
                KEYS[switchView.keys[index]] = "No"
            }
        }
        for sliderView in ViewControllerScout.arraySliderViews {
            sliderView.slider.value = 0
            KEYS[sliderView.key] = 0
        }
        if topMostViewController() == ViewControllerScout.instance {
            self.txtTeamNum.text = ""
            self.txtMatchNum.text = ""
            self.segTeamColor.selectedSegmentIndex = 0
        }
        KEYS[K_TEAM_NUMBER] = "0"
        KEYS[K_TEAM_COLOR] = "Blue"
        KEYS[K_MATCH_NUMBER] = 0
    }
    
    func segTeamColorChanged(_ sender: UISegmentedControl) {
        print("Team color is: \(sender.titleForSegment(at: sender.selectedSegmentIndex)!)")
        switch sender.selectedSegmentIndex {
        case 0:
            self.setColor(UIColor.blue())
            self.setViewColor(CustomView.colorBlueForView)
            KEYS[K_TEAM_COLOR] = "Blue"
        case 1:
            self.setColor(UIColor.red())
            self.setViewColor(CustomView.colorRedForView)
            KEYS[K_TEAM_COLOR] = "Red"
        default: return
        }
    }
    
    func reset() {
        KEYS.removeAllObjects()
        self.setDefaults()
        self.setColor(UIColor.blue())
        self.setViewColor(CustomView.colorBlueForView)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    func setViewColor(_ color: UIColor) {
        self.scrollView.backgroundColor = color
        for labelView in ViewControllerScout.arrayLabelViews {
            labelView.backgroundColor = color
        }
        for segCtrlView in ViewControllerScout.arraySegCtrlViews {
            segCtrlView.backgroundColor = color
        }
        for stepperView in ViewControllerScout.arrayStepperViews {
            stepperView.backgroundColor = color
        }
        for textFieldView in ViewControllerScout.arrayTextFieldViews {
            textFieldView.backgroundColor = color
        }
        for switchView in ViewControllerScout.arraySwitchViews {
            switchView.backgroundColor = color
        }
        for sliderView in ViewControllerScout.arraySliderViews {
            sliderView.backgroundColor = color
        }
        for spaceView in ViewControllerScout.arraySpaceViews {
            spaceView.backgroundColor = color
        }
    }
    
    func startAgain() {
        ViewControllerMain.instance.sendingEOM = false
        ViewControllerMain.instance.sendDataIndex = 0
        ViewControllerMain.instance.dataToSend = nil
        self.reset()
        self.setDefaults()
    }
    
    @IBAction func btnStartBackToMainVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    func closeKeyboard(_ sender: UITapGestureRecognizer) {
        self.scrollView.endEditing(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension ViewControllerScout: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.superview!.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.txtTeamNum:
            if let teamNum = Int(textField.text!) {
                if teamNum > 9999 {
                    alert("That number is too big")
                    textField.text = ""
                } else {
                    print("team num is \(textField.text!)")
                    KEYS[K_TEAM_NUMBER] = teamNum
                }
            } else {
                alert("That is not a number")
                textField.text = ""
            }
        case self.txtMatchNum:
            if let matchNum = Int(textField.text!) {
                if matchNum > 200 {
                    alert("There is no way this is match \(matchNum)")
                    textField.text = ""
                } else {
                    KEYS[K_MATCH_NUMBER] = matchNum
                    print("match num is \(textField.text!)")
                }
            } else {
                alert("That is not a number")
                textField.text = ""
            }
        default:
            break
        }
    }
}
