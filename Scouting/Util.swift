//
//  Operator.swift
//  Scouting
//
//  Created by Alex DeMeo on 2/24/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import Foundation

infix operator += {}

func +=(start: inout String!, append: String) {
    start.append("\(append)\n")
}

func +=(start: inout NSString, append: NSString) {
    start = "\(start)\(append)"
}

func +=(start: inout String, append: NSString) {
    start.append("\(append)")
}

func +=(start: inout NSString, append: String) {
    start = "\(start)\(append)"
}

extension Data {
    func toDataArray(_ MTU: Int) -> [Data] {
        var index = 0
        var arr = [Data]()
        let lastBit = self.count % MTU
        let nIterations = (self.count - lastBit) / MTU
        for i in 0...nIterations {
            let chunk = Data(bytes: UnsafePointer<UInt8>((self as NSData).bytes + index), count: i == nIterations ? lastBit : MTU)
            arr.append(chunk)
            index += MTU
            
        }
        return arr
    }
}

extension Array {
    mutating func sortAlphabetically() {
        self = self.sorted(isOrderedBefore: {
            return String($0) < String($1)
        })
    }
}
