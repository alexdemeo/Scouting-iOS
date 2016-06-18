//
//  LoadFile.swift
//  InterfaceConstruction
//
//  Created by Alex DeMeo on 1/5/16.
//  Copyright © 2016 Alex DeMeo. All rights reserved.
//

import UIKit


struct FileUtil {
    internal static var fileContents: String! = ""
    internal static var fileContentsTrimmed: [String]! = [String]()
    internal static var allKeys: [String] = [String]()

    static func loadFileToString() {
        let path = Bundle.main().pathForResource("config", ofType: "txt")
        var str: NSString!
        do {
            str = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
        } catch {
            print(error)
        }
        FileUtil.fileContents = "\(str)"
        FileUtil.trimFileContents(FileUtil.fileContents)
        FileUtil.createKeysList()
        
    }
    
    private static func createKeysList() {
        for line in FileUtil.fileContentsTrimmed {
            if !(line.hasPrefix("SPACE") || line.hasPrefix("LABEL")) {
                let parts = line.components(separatedBy: ";;")
                let key = parts[(parts.endIndex - 1)].trim()
                FileUtil.allKeys.append(key)
            }
        }
    }
    
    private static func trimFileContents(_ contents: String) {
        let lines = contents.components(separatedBy: "\n")
        var trimmedLines: [String]! = [String]()
        
        for line in lines {
            if !line.hasPrefix("##") && !line.isEmpty && !line.hasPrefix("@"){
                trimmedLines.append(line)
            }
        }
        FileUtil.fileContentsTrimmed = trimmedLines
    }
}
