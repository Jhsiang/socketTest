//
//  ANSI.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/8/7.
//  Copyright © 2018年 nhr. All rights reserved.
//

import Foundation

/*
protocol AnsiColorEscaped {
    func ansi(code: Int) -> AnsiColorEscaped
}

extension AnsiColorEscaped {
    var bold: AnsiColorEscaped { return ansi(code: 1) }
    var underline: AnsiColorEscaped { return ansi(code: 4) }
    var blink: AnsiColorEscaped { return ansi(code: 5) }
    var black: AnsiColorEscaped { return ansi(code: 30) }
    var red: AnsiColorEscaped { return ansi(code: 31) }
    var green: AnsiColorEscaped { return ansi(code: 32) }
    var yellow: AnsiColorEscaped { return ansi(code: 33) }
    var blue: AnsiColorEscaped { return ansi(code: 34) }
    var magenta: AnsiColorEscaped { return ansi(code: 35) }
    var cyan: AnsiColorEscaped { return ansi(code: 36) }
    var whhite: AnsiColorEscaped { return ansi(code: 37) }
    var bgblack: AnsiColorEscaped { return ansi(code: 40) }
    var bgred: AnsiColorEscaped { return ansi(code: 41) }
    var bggreen: AnsiColorEscaped { return ansi(code: 42) }
    var bgyellow: AnsiColorEscaped { return ansi(code: 43) }
    var bgblue: AnsiColorEscaped { return ansi(code: 44) }
    var bgmagenta: AnsiColorEscaped { return ansi(code: 45) }
    var bgcyan: AnsiColorEscaped { return ansi(code: 46) }
    var bgwhite: AnsiColorEscaped { return ansi(code: 47) }
}

struct AnsiColorEscapedString: AnsiColorEscaped, CustomStringConvertible {
    //private
    let string: String
    //private
    let codes: Set<Int>

    func ansi(code: Int) -> AnsiColorEscaped {
        var codes = self.codes
        codes.insert(code)
        return AnsiColorEscapedString(string: string, codes: codes)
    }

    var description: String {
        //return "\u{001B}[" + ";".join(codes.map { "\($0)" }) + "m" + string + "\u{001B}[0m"
        let codeStrings = codes.map { String($0) }
        return "\u{001B}[" + codeStrings.joined(separator: ";") + "m" + string + "\u{001B}[0m"
    }
}
//initializer is inaccessible due to private protection level
extension String: AnsiColorEscaped {
    func ansi(code: Int) -> AnsiColorEscaped {
        return AnsiColorEscapedString(string: self, codes: Set([code]))
    }
}

func +(lhs: AnsiColorEscaped, rhs: AnsiColorEscaped) -> AnsiColorEscaped {
    return "\(lhs)\(rhs)"
}
*/


var colorCodes:[String:Int] = [
    "black": 30,
    "red": 31,
    "green": 32,
    "yellow": 33,
    "blue": 34,
    "magenta": 35,
    "cyan": 36,
    "white": 37
]

var bgColorCodes:[String:Int] = [
    "blackBackground": 40,
    "redBackground": 41,
    "greenBackground": 42,
    "yellowBackground": 43,
    "blueBackground": 44,
    "magentaBackground": 45,
    "cyanBackground": 46,
    "whiteBackground": 47
]

var styleCodes:[String:Int] = [
    "reset": 0,
    "bold": 1,
    "italic": 3,
    "underline": 4,
    "inverse": 7,
    "strikethrough": 9,
    "boldOff": 22,
    "italicOff": 23,
    "underlineOff": 24,
    "inverseOff": 27,
    "strikethroughOff": 29
]

func getCode(_ key: String) -> Int? {
    if colorCodes[key] != nil {
        return colorCodes[key]
    }
    else if bgColorCodes[key] != nil {
        return bgColorCodes[key]
    }
    else if styleCodes[key] != nil {
        return styleCodes[key]
    }

    return nil
}

func addCodeToCodesArray(_ codes: Array<Int>, code: Int) -> Array<Int> {
    var result:Array<Int> = codes

    if colorCodes.values.contains(code) {
        result = result.filter { !colorCodes.values.contains($0) }
    }
    else if bgColorCodes.values.contains(code) {
        result = result.filter { !bgColorCodes.values.contains($0) }
    }
    else if code == 0 {
        return []
    }

    if !result.contains(code) {
        result.append(code)
    }

    return result
}

func matchesForRegexInText(_ regex: String!, text: String!, global: Bool = false) -> [String] {
    let regex = try! NSRegularExpression(pattern: regex, options: [])
    let nsString = text as NSString
    let results = regex.matches(in: nsString as String, options: [], range: NSMakeRange(0, nsString.length))

    if !global && results.count == 1 {
        var result:[String] = []

        for i in 0..<results[0].numberOfRanges {
            result.append(nsString.substring(with: results[0].range(at: i)))
        }

        return result
    }
    else {
        return results.map { nsString.substring(with: $0.range) }
    }
}

struct ANSIGroup {
    var codes:[Int]
    var string:String

    func toString() -> String {
        let codeStrings = codes.map { String($0) }
        return "\u{001B}[" + codeStrings.joined(separator: ";") + "m" + string + "\u{001B}[0m"
    }
}

func parseExistingANSI(_ string: String) -> [ANSIGroup] {
    var results:[ANSIGroup] = []

    let matches = matchesForRegexInText("\\u001B\\[([^m]*)m(.+?)\\u001B\\[0m", text: string, global: true)

    for match in matches {
        var parts = matchesForRegexInText("\\u001B\\[([^m]*)m(.+?)\\u001B\\[0m", text: match),
        codes = parts[1].characters.split {$0 == ";"}.map { String($0) },
                                                          string = parts[2]

        results.append(ANSIGroup(codes: codes.filter { Int($0) != nil }.map { Int($0)! }, string: string))
    }

    return results
}

func format(_ string: String, _ command: String) -> String {

    if (ProcessInfo.processInfo.environment["DEBUG"] != nil && ProcessInfo.processInfo.environment["DEBUG"]! as String == "true" && (ProcessInfo.processInfo.environment["TEST"] == nil || ProcessInfo.processInfo.environment["TEST"]! as String == "false")) {
        return string
    }

    let code = getCode(command)
    let existingANSI = parseExistingANSI(string)

    if code == nil {
        return string
    } else if existingANSI.count > 0 {
        return existingANSI.map {
            return ANSIGroup(codes: addCodeToCodesArray($0.codes, code: code!), string: $0.string).toString()
            }.joined(separator: "")
    } else {
        let group = ANSIGroup(codes: [code!], string: string)
        return group.toString()
    }
}

public extension String {
    // foregrounds
    var black: String {
        return format(self, "black")
    }
    var red: String {
        return format(self, "red")
    }
    var green: String {
        return format(self, "green")
    }
    var yellow: String {
        return format(self, "yellow")
    }
    var blue: String {
        return format(self, "blue")
    }
    var magenta: String {
        return format(self, "magenta")
    }
    var cyan: String {
        return format(self, "cyan")
    }
    var white: String {
        return format(self, "white")
    }

    // backgrounds
    var blackBackground: String {
        return format(self, "blackBackground")
    }
    var redBackground: String {
        return format(self, "redBackground")
    }
    var greenBackground: String {
        return format(self, "greenBackground")
    }
    var yellowBackground: String {
        return format(self, "yellowBackground")
    }
    var blueBackground: String {
        return format(self, "blueBackground")
    }
    var magentaBackground: String {
        return format(self, "magentaBackground")
    }
    var cyanBackground: String {
        return format(self, "cyanBackground")
    }
    var whiteBackground: String {
        return format(self, "whiteBackground")
    }

    // formats
    var bold: String {
        return format(self, "bold")
    }

    var italic: String {
        return format(self, "italic")
    }

    var underline: String {
        return format(self, "underline")
    }

    var reset: String {
        return format(self, "reset")
    }

    var inverse: String {
        return format(self, "inverse")
    }

    var strikethrough: String {
        return format(self, "strikethrough")
    }

    var boldOff: String {
        return format(self, "boldOff")
    }

    var italicOff: String {
        return format(self, "italicOff")
    }

    var underlineOff: String {
        return format(self, "underlineOff")
    }

    var inverseOff: String {
        return format(self, "inverseOff")
    }

    var strikethroughOff: String {
        return format(self, "strikethroughOff")
    }
}

