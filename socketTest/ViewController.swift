//
//  ViewController.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/8/2.
//  Copyright © 2018年 nhr. All rights reserved.
//

import UIKit
import SwiftSocket
import SwiftyTimer



class ViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {

    let client = TCPClient(address: address1, port: port)

    var mylogArr = Array<String>()

    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var connectBtn: UIButton!

    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var upBtn: UIButton!
    @IBOutlet var downBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    @IBOutlet var enterBtn: UIButton!

    @IBOutlet var displayView: UIView!
    var myScrollView = UIScrollView()
    var myLabel = UILabel()
    var tempStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        

        // Account save
        if let arr = UserDefaults.standard.array(forKey: saveKeyUtf8){
            mylogArr = arr as! Array<String>
        }

        let leftSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(direct(sender:)))
        leftSwipe.direction = .left
        let rightSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(direct(sender:)))
        rightSwipe.direction = .right
        let upSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(direct(sender:)))
        upSwipe.direction = .up
        let downSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(direct(sender:)))
        downSwipe.direction = .down

        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(whenTap))
        let doubleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(whenDTap))
        doubleTap.numberOfTapsRequired = 2
        tap.require(toFail: doubleTap)

        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(upSwipe)
        self.view.addGestureRecognizer(downSwipe)
        self.view.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(doubleTap)

    }

    override func viewDidAppear(_ animated: Bool) {

        //Btn layout
        upBtn.setImage(Graphics.getUpImage(), for: UIControlState.normal)
        downBtn.setImage(Graphics.getDownImage(), for: UIControlState.normal)
        leftBtn.setImage(Graphics.getLeftImage(), for: UIControlState.normal)
        rightBtn.setImage(Graphics.getRightImage(), for: UIControlState.normal)
        enterBtn.setImage(Graphics.getEnterImage(), for: UIControlState.normal)

        myLabel.numberOfLines = 0
        myLabel.textColor = .white

        myScrollView.frame = CGRect(x: 0, y: 0, width: displayView.frame.width, height: displayView.frame.height)
        myScrollView.contentSize = CGSize(width: displayView.frame.width * 5, height: displayView.frame.height)
        myLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: myScrollView.contentSize)
        self.myScrollView.addSubview(myLabel)
        self.displayView.addSubview(myScrollView)
        connect()

    }

    func getLSizeOfLabel() {
        //let width = myLabel.intrinsicContentSize.width
        //DLog(message: width)
        myLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: myScrollView.contentSize)
        myLabel.sizeToFit()
        myScrollView.contentOffset.x = 0
        myScrollView.contentOffset.y = 0
    }

    //MARK: - Gesture
    @objc func whenTap(sender:UITapGestureRecognizer){
        //let sendStr = "enter"
        //sendData(str: sendStr, Enter: true)
        read()
    }

    @objc func whenDTap(){
        if tempStr == ""{
            tempStr = self.myLabel.text!
            self.myLabel.text = ""
            self.view.alpha = 0.05
            getLSizeOfLabel()
        }else{
            self.myLabel.text = tempStr
            tempStr = ""
            self.view.alpha = 1
            getLSizeOfLabel()
        }
    }

    @objc func direct(sender:UISwipeGestureRecognizer){
        var data = [UInt8]()
        if sender.direction == .left{
            data = telnetDic["left"]!
            DLog(message: "left")
        }else if sender.direction == .up{
            data = telnetDic["up"]!
            DLog(message: "up")
        }else if sender.direction == .right{
            data = telnetDic["right"]!
            DLog(message: "right")
        }else if sender.direction == .down{
            data = telnetDic["down"]!
            DLog(message: "down")
        }

        let aa = self.client.send(data: data)
        if aa.isSuccess{
                self.read()
        }else{
            DLog(message: "send fail")
        }
    }


    //MARK: - Button Click


    @IBAction func btnClick(_ sender: UIButton) {
        var data = [UInt8]()
        switch sender {
        case loginBtn:
            if mylogArr.count == 2{
                for i in mylogArr{
                    if client.send(string: i).isSuccess,client.send(data: [13]).isSuccess{
                        //print("login success")
                    }
                }
                if client.send(string: "y").isSuccess,client.send(data: [13]).isSuccess{
                    //print("clean repeate")
                }
            }
            read()
            return

        case connectBtn:
            connect()
            return

        case upBtn:
            data = telnetDic["up"]!
        case downBtn:
            data = telnetDic["down"]!
        case rightBtn:
            data = telnetDic["right"]!
        case leftBtn:
            data = telnetDic["left"]!
        case enterBtn:
            data = [13]

        default:
            DLog(message: "btn click fail")
        }

        let succesCheck = self.client.send(data: data)
        if succesCheck.isSuccess{
            self.read()
        }else{
            DLog(message: "send fail")
        }
    }

    //MARK: - TCP Function
    func read(){
        Timer.after(0.5) {
            if var data = self.client.read(2048*10){
                DLog(message: "data count = \(data.count)")
                var myBreak = true
                var removeCount = 0
                while myBreak == true{
                    if let str = convertUInt8ArrToStr(uint8: data){
                        var noAnsiStr:String? = ""
                        let _ = escapeCodesForString(escapedString: str, cleanString: &noAnsiStr)
                        self.myLabel.text = noAnsiStr!
                        print(noAnsiStr!)
                        self.getLSizeOfLabel()
                        myBreak = false
                    } else {
                        data.removeLast()
                        removeCount += 1
                    }
                }
            }else{
                DLog(message: "my fail read")
            }
        }
    }

    func sendData(str:String,Enter:Bool){
        if !Enter{
            let strArr = Array(str)
            let speed = 0.2
            for i in 0...strArr.count - 1{
                DispatchQueue.main.asyncAfter(deadline: .now()+speed*Double(i)) {
                    let data:[UInt8] = telnetDic[String(strArr[i])]!
                    _ = self.client.send(data: data)
                }
            }
        }else{
            let data:[UInt8] = telnetDic["enter"]!
            _ = client.send(data: data)
        }
    }

    func connect(){
        client.close()
        switch client.connect(timeout: 10) {
        case .success:
            myLabel.text = "connect success"
            DLog(message: "connect success")
            read()
        case .failure(let error):
            myLabel.text = "\(error)"
            DLog(message: error)
        }
    }

    func echoService(client: TCPClient) {
        print("Newclient from:\(client.address)[\(client.port)]")
        let d = client.read(1024*10)
        _ = client.send(data: d!)
        client.close()
    }

    func testServer() {
        let server = TCPServer(address: address1, port: port)
        switch server.listen() {
        case .success:
            while true {
                if let client = server.accept() {
                    echoService(client: client)
                } else {
                    print("accept error")
                }
            }
        case .failure(let error):
            print(error)
        }
    }

    //MARK: - My Function

    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
