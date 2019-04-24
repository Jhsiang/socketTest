//
//  Telnet.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/9/13.
//  Copyright © 2018年 nhr. All rights reserved.
//

import Foundation
import SwiftSocket

protocol TelnetDelegate {
    func responseStr(str:String)
}

class Telnet{
    static let share = Telnet()
    var delegate:TelnetDelegate?
    let client = TCPClient(address: address1, port: port)
    var nowStr = ""
    var nowStrArr = [String]()
    var speed:Float = 0.5

    func connectToTelenet() -> Bool{
        if client.connect(timeout: 10).isSuccess{
            receive()
            return true
        }else{
            return false
        }

    }

    func disConnect(){
        client.close()
    }

    func sendData(data:[Byte]) -> Bool{
        if client.send(data: data).isSuccess{
            receive()
            return true
        }else{
            return false
        }
    }

    func sendString(str:String) -> Bool{
        if client.send(string: str).isSuccess{
            receive()
            return true
        }else{
            return false
        }
    }

    private func receive(){
        let us = UInt32(speed * 1_000_000)
        usleep(us)
        if let data = self.client.read(2048*10){
            /*
            if let str = convertUInt8ArrToStr(uint8: data){
                var noAnsiStr:String? = ""
                let _ = escapeCodesForString(escapedString: str, cleanString: &noAnsiStr)
                self.delegate?.responseStr(str: noAnsiStr!)
                nowStr = noAnsiStr!
                nowStrArr.append(nowStr)
            }
 */
            if let str = converUInt8ArrToStr2(unit8: data){
                var noAnsiStr:String? = ""
                let _ = escapeCodesForString(escapedString: str, cleanString: &noAnsiStr)
                self.delegate?.responseStr(str: noAnsiStr!)
                nowStr = noAnsiStr!
                //nowStrArr.append(nowStr)
            }
        }else{
            self.delegate?.responseStr(str: READ_EMPTY)
        }
    }

}
