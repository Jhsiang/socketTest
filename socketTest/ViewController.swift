//
//  ViewController.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/8/2.
//  Copyright © 2018年 nhr. All rights reserved.
//

import UIKit
import SwiftSocket

//import Darwin.ncurses


let address1 = "140.112.172.1"
let address2 = "140.112.172.2"
let address5 = "140.112.172.5"
let address11 = "140.112.172.11"

let port:Int32 = 23

class ViewController: UIViewController {

    let client = TCPClient(address: address1, port: port)

    @IBOutlet var readBtn: UIButton!
    @IBOutlet var enterBtn: UIButton!
    @IBOutlet var connectBtn: UIButton!

    @IBOutlet var displayLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // string to Uint8Array tested
        let aa = "中\n 中"
        let arr:[UInt8] = Array(aa.utf8)
        DLog(message: arr.map{String($0, radix:16)})
        DLog(message: arr)
        print("")

        /*
        // Uint8Array to String test
        let myArr:[UInt8] = [229, 156, 139]
        if let str = convertUInt8ArrToStr(uint8: myArr){
            DLog(message: str)
            DLog(message: str.removingPercentEncoding)
        }else{
            DLog(message: "convert str fail")
        }
        print("")
        */

        // short test
        let myArr2:[UInt8] = [72, 84, 84, 80, 47, 49, 46, 49, 32, 50, 48, 48, 32, 79, 75, 13, 10, 13, 10, 32, 32, 32, 32, 32, 163, 187, 32]
        if let str = convertUInt8ArrToStr(uint8: myArr2){
            DLog(message: str)
            DLog(message: str.removingPercentEncoding)
        }else{
            DLog(message: "convert str fail")
        }
        print("")

        // total test
        if let str = convertUInt8ArrToStr(uint8: totalArr){
            DLog(message: str)
            DLog(message: str.removingPercentEncoding)
        }else{
            DLog(message: "convert str fail")
        }


    }

    @IBAction func btnClick(_ sender: UIButton) {
        switch sender {

        case readBtn:
            if var data = client.read(1024*10){
                DLog(message: "data count = \(data.count)")
                var myBreak = true
                while myBreak == true{
                    if let string = convertUInt8ArrToStr(uint8: data){
                        displayLabel.text = string
                        print(string)
                        myBreak = false
                    } else {
                        data.removeLast()
                    }
                }
                //DLog(message: data)
                DLog(message: "data count = \(data.count)")
            }else{
                DLog(message: "my fail read")
            }

        case enterBtn:
            /*
             let data:[UInt8] = [13] //return key(Enter)
             let result = self.client.send(data: data)
             */
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                let data:[UInt8] = telnetDic["g"]!
                let result = self.client.send(data: data)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                let data:[UInt8] = telnetDic["u"]!
                let result = self.client.send(data: data)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                let data:[UInt8] = telnetDic["e"]!
                let result = self.client.send(data: data)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+4) {
                let data:[UInt8] = telnetDic["s"]!
                let result = self.client.send(data: data)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+5) {
                let data:[UInt8] = telnetDic["t"]!
                let result = self.client.send(data: data)
            }
//            DispatchQueue.main.asyncAfter(deadline: .now()+6) {
//                let data:[UInt8] = telnetDic["."]!
//                let result = self.client.send(data: data)
//            }
            DispatchQueue.main.asyncAfter(deadline: .now()+7) {
                let data:[UInt8] = telnetDic["enter"]!
                let result = self.client.send(data: data)
            }
            break

        case connectBtn:
            connect()

        default:
            DLog(message: "btn click fail")
        }
    }


    func connect(){
        switch client.connect(timeout: 10) {
        case .success:
            DLog(message: "connect success")
        case .failure(let error):
            DLog(message: error)
        default:
            DLog(message: "Unknow issue")
        }
    }


    func echoService(client: TCPClient) {
        print("Newclient from:\(client.address)[\(client.port)]")
        var d = client.read(1024*10)
        client.send(data: d!)
        client.close()
    }

    func testServer() {
        let server = TCPServer(address: address1, port: port)
        switch server.listen() {
        case .success:
            while true {
                if var client = server.accept() {
                    echoService(client: client)
                } else {
                    print("accept error")
                }
            }
        case .failure(let error):
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

