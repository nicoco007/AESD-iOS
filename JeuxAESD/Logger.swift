//
//  Logger.swift
//  JeuxAESD
//
//  Created by Nicolas Gnyra on 17-04-08.
//  Copyright © 2017 Nicolas Gnyra. All rights reserved.
//

import Foundation

class Logger {
    static var verboseEnabled = false
    
    static func verbose<T>(_ text: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        if verboseEnabled {
            write(text, " VERBOSE", file, function, line)
        }
    }
    static func debug<T>(_ text: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        write(text, "   DEBUG", file, function, line)
    }
    
    static func info<T>(_ text: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        write(text, "    INFO", file, function, line)
    }
    
    static func warn<T>(_ text: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        write(text, " WARNING", file, function, line)
    }
    
    static func error<T>(_ text: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        write(text, "   ERROR", file, function, line)
    }
    
    private static func write<T>(_ message: T, _ level: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        // get datetime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        let dateString = dateFormatter.string(from: Date())
        
        // get file name without path
        let fileName = (file as NSString).lastPathComponent
        
        let text = String(describing: message)
        
        print("\(dateString) | \(level) | [\(fileName):\(line)] \(text)")
    }
}
