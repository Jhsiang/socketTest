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

        displayLabel.adjustsFontSizeToFitWidth = true
/*
        do {
            var aa:[UInt8] = [72, 84, 84, 80, 47, 49, 13, 10, 72, 84, 84, 80, 47, 49]
            //var aa = totalArr
            displayLabel.text = convertUInt8ArrToStr(uint8: aa)
            var myBreak = true
            DLog(message: aa.count)
            while myBreak == true{
                if let str = convertUInt8ArrToStr(uint8: aa){
                    myBreak = false
                    //displayLabel.text = str
                    DLog(message: displayLabel.text!)
                    DLog(message: str)
                }else{
                    aa.removeLast()
                }
            }
            DLog(message: aa.count)
            //DLog(message: convertUInt8ArrToStr(uint8: aa))
        }
 */
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
            let speed = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now()+speed*1) {
                let data:[UInt8] = telnetDic["g"]!
                let result = self.client.send(data: data)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+speed*2) {
                let data:[UInt8] = telnetDic["u"]!
                let result = self.client.send(data: data)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+speed*3) {
                let data:[UInt8] = telnetDic["e"]!
                let result = self.client.send(data: data)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+speed*4) {
                let data:[UInt8] = telnetDic["s"]!
                let result = self.client.send(data: data)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+speed*5) {
                let data:[UInt8] = telnetDic["t"]!
                let result = self.client.send(data: data)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+speed*6) {
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

