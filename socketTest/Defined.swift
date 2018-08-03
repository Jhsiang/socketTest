//
//  Defined.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/8/2.
//  Copyright © 2018年 nhr. All rights reserved.
//

import Foundation

func DLog<T> (message: T, fileName: String = #file, funcName: String = #function, lineNum: Int = #line) {

    #if DEBUG

    let file = (fileName as NSString).lastPathComponent

    print("-\(file) \(funcName)-[\(lineNum)]: \(message)")

    #endif

}

func convertStrToUInt8Arr(str:String) -> [UInt8]{
    return Array(str.utf8)
}

func convertUInt8ArrToStr(uint8:[UInt8]) -> String? {
    let cfEnc = CFStringEncodings.big5
    let nsEnc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
    let big5encoding = String.Encoding(rawValue: nsEnc) // String.Encoding

    if let str = String(bytes: uint8, encoding: big5encoding) {
        return str
        let aa = str.removingPercentEncoding
        return aa!.removingPercentEncoding
    }else{
        return nil
    }
}



let telnetDic:[String:[UInt8]] = [
    ",":[44],
    ".":[46],
    "g":[103],
    "u":[117],
    "e":[101],
    "s":[115],
    "t":[116],
    "enter":[13]]
