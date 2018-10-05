//
//  Defined.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/8/2.
//  Copyright © 2018年 nhr. All rights reserved.
//

import Foundation

//extension String{
//    func substring(from index: Int) -> String {
//        if self.characters.count > index {
//            let startIndex = self.index(self.startIndex, offsetBy: index)
//            let subString = self[startIndex..<self.endIndex]
//
//            return String(subString)
//        } else {
//            return self
//        }
//    }
//}

func DLog<T> (message: T, fileName: String = #file, funcName: String = #function, lineNum: Int = #line) {

    #if DEBUG

    let file = (fileName as NSString).lastPathComponent

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
    let sendDate = Date()
    let timeStr = dateFormatter.string(from: sendDate)

    print("-\(timeStr) \(file) \(funcName)-[\(lineNum)]: \(message)")

    #endif

}

func convertStrToUInt8Arr(str:String) -> [UInt8]{
    return Array(str.utf8)
}

func convertUInt8ArrToStr(uint8:[UInt8]) -> String? {

    var myUInt8 = uint8
    //DLog(message: "before data count = \(myUInt8.count)")
    let cfEnc = CFStringEncodings.big5
    let nsEnc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
    let big5encoding = String.Encoding(rawValue: nsEnc) // String.Encoding

    while myUInt8.count > 0 {
        if let str = String(bytes: myUInt8, encoding: .utf8){
            //DLog(message: "after data count = \(myUInt8.count)")
            return str
        }else{
            myUInt8.removeLast()
        }
    }

    DLog(message: "after data count = \(myUInt8.count)")
    return nil

}

public struct EscapeCharacters {
    static let CSI: String = "["
    static let SGREnd = "m"
}

struct AttributeKeys {
    static let name = "attributeName"
    static let value = "attributeValue"
    static let range = "range"
    static let code = "code"
    static let location = "location"
}

func escapeCodesForString(escapedString: String, cleanString: inout String?) -> [[String: Any]] {
    let aString = escapedString as NSString
    if (aString == "") {
        return []
    }

    if (aString.length <= EscapeCharacters.CSI.count) {
        return []
    }

    var formatCodes = [[String: Any]]()

    var aStringLength = aString.length
    var coveredLength = 0

    var searchRange = NSMakeRange(0, aStringLength)
    var sequenceRange: NSRange
    var thisCoveredLength: Int = 0
    var searchStart: Int = 0

    repeat
    {
        sequenceRange = aString.range(of: EscapeCharacters.CSI, options: .literal, range: searchRange) //find literal

        if (sequenceRange.location != NSNotFound) {

            thisCoveredLength = sequenceRange.location - searchRange.location
            coveredLength += thisCoveredLength

            formatCodes += codesForSequence(sequenceRange: &sequenceRange, string: aString).map { code in
                [AttributeKeys.code: code, AttributeKeys.location: coveredLength]
            }

            if (thisCoveredLength > 0) {
                cleanString = cleanString?.appending(aString.substring(with: NSMakeRange(searchRange.location, thisCoveredLength)))
            }

            searchStart = NSMaxRange(sequenceRange)
            searchRange = NSMakeRange(searchStart, aStringLength - searchStart)
        }
    } while(sequenceRange.location != NSNotFound)

    if (searchRange.length > 0) {
        cleanString = cleanString?.appending(aString.substring(with: searchRange))
    }

    return formatCodes
}

func codesForSequence(sequenceRange: inout NSRange, string: NSString) -> [Int] {
    var codes = [Int]()
    var code = 0
    var lengthAddition = 1
    var thisIndex: Int

    while(true)
    {
        thisIndex = (NSMaxRange(sequenceRange) + lengthAddition - 1)

        if (thisIndex >= string.length) {
            break
        }

        var c: Int = Int(string.character(at: thisIndex))

        if ((48 <= c) && (c <= 57))
        {
            let digit: Int = c - 48
            code = (code == 48) ? digit : code * 10 + digit
        }

        if (c == 109)
        {
            codes.append(code)
            break
        } else if ((64 <= c) && (c <= 126)) {
            codes.removeAll(keepingCapacity: false)
            break
        } else if (c == 59) {
            codes.append(code)
            code = 0
        }

        lengthAddition += 1
    }

    sequenceRange.length += lengthAddition

    return codes
}












let telnetDic:[String:[UInt8]] = [
    "A":[65],
    "B":[66],
    "C":[67],
    "D":[68],
    "E":[69],
    "F":[70],
    "G":[71],
    "H":[72],
    "I":[73],
    "J":[74],
    "K":[75],
    "L":[76],
    "M":[77],
    "N":[78],
    "O":[79],
    "P":[80],
    "Q":[81],
    "R":[82],
    "S":[83],
    "T":[84],
    "U":[85],
    "V":[86],
    "W":[87],
    "X":[88],
    "Y":[89],
    "Z":[90],
    "a":[97],
    "b":[98],
    "c":[99],
    "d":[100],
    "e":[101],
    "f":[102],
    "g":[103],
    "h":[104],
    "i":[105],
    "j":[106],
    "k":[107],
    "l":[108],
    "m":[109],
    "n":[110],
    "o":[111],
    "p":[112],
    "q":[113],
    "r":[114],
    "s":[115],
    "t":[116],
    "u":[117],
    "v":[118],
    "w":[119],
    "x":[120],
    "y":[121],
    "z":[122],
    "0":[48],
    "1":[49],//0x31
    "2":[50],
    "3":[51],
    "4":[52],//0x34
    "5":[53],//0x35
    "6":[54],//0x36
    "7":[55],
    "8":[56],
    "9":[57],
    ",":[44],
    ".":[46],
    "~":[0x7E],
    "up":[0x1B,0x5B,0x41],
    "down":[0x1B,0x5B,0x42],
    "right":[0x1B,0x5B,0x43],
    "left":[0x1B,0x5B,0x44],
    "pageUp":[0x1B,0x5B,53,0x7E],
    "pageDown":[0x1B,0x5B,54,0x7E],
    "home":[0x1B,0x5B,0x31,0x7E],
    "end":[0x1B,0x5B,0x34,0x7E],
    "enter":[13]
]
