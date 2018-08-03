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

        let aa = "國"
        let arr:[UInt8] = Array(aa.utf8)
        DLog(message: arr)


        //connect()

    }

    @IBAction func btnClick(_ sender: UIButton) {
        switch sender {
        case readBtn:
            if var data = client.read(1024*10){
                DLog(message: "data count = \(data.count)")
                var myBreak = true
                while myBreak == true{
                    if let string = String(bytes: data, encoding: .ascii) {
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
            let data:[UInt8] = [13] //return key(Enter)
            let result = self.client.send(data: data)
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

