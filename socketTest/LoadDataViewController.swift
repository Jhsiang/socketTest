//
//  LoadDataViewController.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/9/13.
//  Copyright © 2018年 nhr. All rights reserved.
//

import UIKit



class LoadDataViewController: UIViewController,TelnetDelegate {

    var enterFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        Telnet.share.delegate = self
    }

    func send<T>(_ data:T) -> Bool{
        if data is String{
            return Telnet.share.sendString(str: data as! String)
        }else if data is [UInt8]{
            return Telnet.share.sendData(data: data as! [UInt8])
        }else if data is [Int]{
            let data = data as! [Int]
            return Telnet.share.sendData(data: data.map{UInt8(abs($0) % 256)})
        }
        return false
    }

    override func viewDidAppear(_ animated: Bool) {
        Telnet.share.disConnect()
        if Telnet.share.connectToTelenet(){
            if let arr = UserDefaults.standard.array(forKey: saveKeyUtf8){
                let account = arr[0] as! String
                let password = arr[1] as! String
                var mainCheck = account
                mainCheck.removeLast()

                // Login
                if send(account),send([13]),send(password),send([13]),send("F"){
                    while Telnet.share.nowStr == "read_EMPTY"{
                        if send([13]){
                            DLog(message: "Enter Now")
                        }else{
                            DLog(message: "Break Now")
                            break
                        }
                    }

                    if Telnet.share.nowStr.contains(repeatLoginStr){
                        repeateHandle()
                    }else if Telnet.share.nowStr.contains(mainCheck){
                        mainHandle()
                    }else{
                        elseHandle()
                    }
                }
            }
        }else{
            DLog(message: "connect fail")
        }
    }

    func repeateHandle(){
        DLog(message: "I am repeat")

        if send([8]),send([8]),send("Y"),send([13]),send(["F"]),send(["F"]),send([13]){
            saveFavorite(str: Telnet.share.nowStr, index: 1)
            if send(telnetDic["pageDown"]){
                saveFavorite(str: Telnet.share.nowStr, index: 2)
                if send(telnetDic["pageDown"]){
                    saveFavorite(str: Telnet.share.nowStr, index: 3)
                    if send(telnetDic["pageDown"]){
                        saveFavorite(str: Telnet.share.nowStr, index: 4)
                    }
                }
            }
        }

        self.performSegue(withIdentifier: "seque_load_to_favorite", sender: nil)
    }

    func mainHandle(){
        DLog(message: "I am Main check")
        if send("F"),send("F"),send([13]){
            saveFavorite(str: Telnet.share.nowStr, index: 1)
            if send(telnetDic["pageDown"]){
                saveFavorite(str: Telnet.share.nowStr, index: 2)
                if send(telnetDic["pageDown"]){
                    saveFavorite(str: Telnet.share.nowStr, index: 3)
                    if send(telnetDic["pageDown"]){
                        saveFavorite(str: Telnet.share.nowStr, index: 4)
                    }
                }
            }
        }
        self.performSegue(withIdentifier: "seque_load_to_favorite", sender: nil)
    }

    func elseHandle(){
        DLog(message: "I am else")
        if send("F"),send("F"),send([13]){
            saveFavorite(str: Telnet.share.nowStr, index: 1)
            if send(telnetDic["pageDown"]){
                saveFavorite(str: Telnet.share.nowStr, index: 2)
                if send(telnetDic["pageDown"]){
                    saveFavorite(str: Telnet.share.nowStr, index: 3)
                    if send(telnetDic["pageDown"]){
                        saveFavorite(str: Telnet.share.nowStr, index: 4)
                    }
                }
            }
        }
        self.performSegue(withIdentifier: "seque_load_to_favorite", sender: nil)
    }

    func saveFavorite(str:String, index:Int){
        print("save")
        let from = 1 + (index - 1) * 20
        let end = 20 + (index - 1) * 20
        for i in from...end{

            // 判斷優先權
            var select = 0
            var rangeNum = 999999
            if let range = str.range(of: "\(i)   \u{08}\u{08}\u{1B}ˇ\u{1B}\u{1B}"){
                let nowNum = str.distance(from: str.startIndex, to: range.upperBound)
                rangeNum = nowNum
                select = 1
            }
            if let range = str.range(of: "\(i)   \u{1B}"){
                let nowNum = str.distance(from: str.startIndex, to: range.upperBound)
                if nowNum < rangeNum{
                    rangeNum = nowNum
                    select = 2
                }
            }

            if select == 1{
                if let range = str.range(of: "\(i)   \u{08}\u{08}\u{1B}ˇ\u{1B}\u{1B}"){
                    let startIndex = range.upperBound
                    let tempStr = str[startIndex..<str.endIndex]
                    if let range2 = tempStr.range(of: " "){
                        let endIndex = range2.lowerBound
                        var favoriteStr = String(str[startIndex..<endIndex])
                        favoriteStr = favoriteStr.replacingOccurrences(of: "ˇ", with: "")
                        favoriteArrKey.append(favoriteStr)
                    }
                }
            }else if select == 2{
                if let range = str.range(of: "\(i)   \u{1B}"){
                    let startIndex = range.upperBound
                    let tempStr = str[startIndex..<str.endIndex]
                    if let range2 = tempStr.range(of: " "){
                        let endIndex = range2.lowerBound
                        var favoriteStr = String(str[startIndex..<endIndex])
                        favoriteStr = favoriteStr.replacingOccurrences(of: "ˇ", with: "")
                        favoriteArrKey.append(favoriteStr)
                    }
                }
            }else{
                break
            }
        }

        var valueStr = str

        while valueStr.contains("◎\u{1B}") {
            if let range = valueStr.range(of: "◎\u{1B}"){
                let startIndex = range.upperBound
                let tempStr = valueStr[startIndex..<valueStr.endIndex]
                if let range2 = tempStr.range(of: "  "){
                    let endIndex = range2.lowerBound
                    let favoriteStr = String(valueStr[startIndex..<endIndex])
                    favoriteArrValue.append(favoriteStr)
                }
                valueStr = String(tempStr)
            }
        }

        print("key count = \(favoriteArrKey.count)")
        print("value count = \(favoriteArrValue.count)")

        //self.performSegue(withIdentifier: "seque_load_to_favorite", sender: nil)
    }

    //MARK: - TelenetDelegate
    func responseStr(str: String) {
        //DLog(message: str)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
