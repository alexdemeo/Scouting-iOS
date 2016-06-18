//
//  ViewControllerSummary.swift
//  Scouting
//
//  Created by Alex DeMeo on 2/18/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit


class ViewControllerData: UIViewController, UITableViewDelegate, UITableViewDataSource {
    internal static var instance: ViewControllerData!
    
    var teamDictionary: NSDictionary!
    //    var teamArrUnsorted = [(key: AnyObject, value: AnyObject)]()
    //    var teamArrKeysTemp = [AnyObject]()
    //    var teamArrSorted = [(key: AnyObject, value: AnyObject)]()
    var gestureCloseKeyboard: UITapGestureRecognizer!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblTeamNum: UILabel!
    @IBOutlet var lblNumMatches: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if teamDictionary == nil {
            print("No Team dictionary")
            return
        }
        self.gestureCloseKeyboard = UITapGestureRecognizer(target: self, action: #selector(ViewControllerData.closeKeyboard(_:)))
        self.view.addGestureRecognizer(self.gestureCloseKeyboard)
        self.lblTeamNum.text = "\(self.teamDictionary.object(forKey: "team_num")!)"
        self.lblNumMatches.text = "\(self.teamDictionary.object(forKey: "num_matches")!)"
        /*
         for (_, val) in self.teamDictionary.enumerate() {
         teamArrUnsorted.append(val)
         teamArrKeysTemp.append(val.key)
         }
         
         teamArrKeysTemp = teamArrKeysTemp.sort({
         one, two -> Bool in
         let s0 = "\(one)"
         let s1 = "\(two)"
         return s0 < s1
         })
         
         for (index, key) in self.teamArrKeysTemp.enumerate() {
         var key = "\(key)"
         key.replaceRange(key.startIndex...key.startIndex, with: "\(key.characters.first!)".uppercaseString)
         let parts = key.componentsSeparatedByString("_")
         key = ""
         for part in parts {
         key += " \(part)"
         }
         teamArrSorted.append((key, self.teamArrUnsorted[index].value))
         print("\(key)=\(self.teamArrUnsorted[index].value)")
         }*/
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FileUtil.fileContentsTrimmed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "")
        let index = (indexPath as NSIndexPath).row
        
        let col: String = ViewControllerScout.allPrettyKeys[index]
        var raw: Double = 0
        var avg: Double = 0
        let nMatches = Int(self.lblNumMatches.text!)!
        let key = ViewControllerScout.prettyToKey[col]!
    
        switch ViewControllerScout.keyToType[key]! {
        case "switch":
            raw = Double(teamDictionary.object(forKey: key.lowercased()) as! String)!
            avg = raw / Double(nMatches)
        case "segctrl":
            raw = Double(teamDictionary.object(forKey: key.lowercased()) as! String)!
            avg = raw / Double(nMatches)
        case "stepper":
            raw = Double(teamDictionary.object(forKey: key.lowercased()) as! String)!
            avg = raw / Double(nMatches)
        case "textfield":
            if let r = Double(teamDictionary.object(forKey: key.lowercased()) as! String) {
                raw = r
                avg = raw / Double(nMatches)
            } else {
                break
            }
        case "slider":
            raw = Double(teamDictionary.object(forKey: key.lowercased()) as! String)!
            avg = raw / Double(nMatches)
        default: break
        }
        let nf = NumberFormatter()
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.maximumFractionDigits = 2
        self.build(&cell, col: col, raw: "\(raw)", average: nf.string(from: avg)!)
        return cell
    }
    
    func format(_ raw: Double, nMatches: Int) -> Double {
        return Double(raw / Double(nMatches))
    }
    
    @IBAction func btnGoBack(_ sender: UIButton) {
        print("GO BACK")
        self.dismiss(animated: true, completion: {
            ViewControllerRequest.instance.dismiss(animated: true, completion: {})
        })
    }
    
    private func toIntFromDict(_ key: String) -> Int {
        return Int("\(teamDictionary[key]!)")!
    }
    
    private func toStringFromDict(_ key: String) -> String {
        return "\(teamDictionary[key]!)"
    }
    
    func closeKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    class func reinstantiate(_ dict: NSMutableDictionary) {
        ViewControllerData.instance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Data") as! ViewControllerData
        ViewControllerData.instance.teamDictionary = dict
    }
    
    func build(_ cell: inout UITableViewCell, col: String, raw: String, average: String) {
        var lbls = [UILabel]()
        let tableWidth = self.tableView.frame.width
        lbls.append(UILabel(frame: CGRect(x: 0, y: 0, width: tableWidth / 1.5, height: cell.frame.height)))
        lbls.append(UILabel(frame: CGRect(x: tableWidth / 3 + 50, y: 0, width: tableWidth / 3, height: cell.frame.height)))
        lbls.append(UILabel(frame: CGRect(x: tableWidth * (2/3), y: 0, width: tableWidth / 3, height: cell.frame.height)))
        lbls[0].text = col
        lbls[0].textAlignment = NSTextAlignment.left
        lbls[0].font = UIFont.systemFont(ofSize: 10)
        lbls[1].text = raw
        lbls[1].textAlignment = NSTextAlignment.center
        lbls[2].text = average
        lbls[2].textAlignment = NSTextAlignment.right
        
        for lbl in lbls {
            lbl.font = UIFont.systemFont(ofSize: 12)
            cell.addSubview(lbl)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

