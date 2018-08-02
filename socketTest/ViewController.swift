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

    override func viewDidLoad() {
        super.viewDidLoad()

        ///* Uint8 check
        //let aa = "&#x570B"


        connect()

        //let data: Data = // ... Bytes you want to send
        //let result = client.send(data: data)

    }

    func connect(){
        let client = TCPClient(address: address1, port: port)
        switch client.connect(timeout: 10) {
        case .success:
            DLog(message: "connect success")

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if var data = client.read(1024*10){
                    var myBreak = true
                    while myBreak == true{
                        if let string = String(bytes: data, encoding: .utf8) {
                            print(string)
                            myBreak = false
                        } else {
                            data.removeLast()
                        }
                    }
                    DLog(message: data)
                }else{
                    DLog(message: "fail 1")
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                //let data2: Data = "wr".data(using: .utf8)!// ... Bytes you want to send
                let data2:[UInt8] = [13]
                let result = client.send(data: data2)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                if var data = client.read(1024*10){
                    var myBreak = true
                    while myBreak == true{
                        if let string = String(bytes: data, encoding: .utf8) {
                            print(string)
                            myBreak = false
                        } else {
                            data.removeLast()
                        }
                    }
                    DLog(message: data)
                }else{
                    DLog(message: "fail 1")
                }
            }

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

