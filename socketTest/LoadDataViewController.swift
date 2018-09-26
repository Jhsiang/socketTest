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

    override func viewDidAppear(_ animated: Bool) {
        Telnet.share.disConnect()
        if Telnet.share.connectToTelenet(){
            if let arr = UserDefaults.standard.array(forKey: saveKeyUtf8){
                let account = arr[0] as! String
                let password = arr[1] as! String
                var mainCheck = account
                mainCheck.removeLast()
                if Telnet.share.sendString(str: account){
                    if Telnet.share.sendData(data: [13]){
                        if Telnet.share.sendString(str: password){
                            if Telnet.share.sendData(data: [13]){
                                    let isRepeate = Telnet.share.nowStr.contains(repeatLoginStr)
                                    if isRepeate
                                    {
                                        DLog(message: "I am repeat")
                                        if Telnet.share.sendString(str: "y"){
                                            if Telnet.share.sendData(data: telnetDic["up"]!){
                                                if Telnet.share.sendData(data: telnetDic["right"]!){
                                                    saveFavorite(str: Telnet.share.nowStr, index: 1)
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if !Telnet.share.nowStr.contains(mainCheck){
                                            if Telnet.share.sendData(data: [13]){
                                                if Telnet.share.sendData(data: telnetDic["F"]!){
                                                    if Telnet.share.sendData(data: telnetDic["F"]!){
                                                        if Telnet.share.sendData(data: telnetDic["enter"]!){
                                                            saveFavorite(str: Telnet.share.nowStr, index: 1)
                                                            if Telnet.share.sendData(data: telnetDic["pageDown"]!){
                                                                saveFavorite(str: Telnet.share.nowStr, index: 2)
                                                                if Telnet.share.sendData(data: telnetDic["pageDown"]!){
                                                                    saveFavorite(str: Telnet.share.nowStr, index: 3)
                                                                    if Telnet.share.sendData(data: telnetDic["pageDown"]!){
                                                                        saveFavorite(str: Telnet.share.nowStr, index: 4)
                                                                        self.performSegue(withIdentifier: "seque_load_to_favorite", sender: nil)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }else{
                                            if Telnet.share.sendData(data: telnetDic["F"]!){
                                                if Telnet.share.sendData(data: telnetDic["F"]!){
                                                    if Telnet.share.sendData(data: telnetDic["enter"]!){
                                                        saveFavorite(str: Telnet.share.nowStr, index: 1)
                                                        if Telnet.share.sendData(data: telnetDic["pageDown"]!){
                                                            saveFavorite(str: Telnet.share.nowStr, index: 2)
                                                            if Telnet.share.sendData(data: telnetDic["pageDown"]!){
                                                                saveFavorite(str: Telnet.share.nowStr, index: 3)
                                                                if Telnet.share.sendData(data: telnetDic["pageDown"]!){
                                                                    saveFavorite(str: Telnet.share.nowStr, index: 4)
                                                                    self.performSegue(withIdentifier: "seque_load_to_favorite", sender: nil)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                }

/*
                                if Telnet.share.nowStr.contains(repeatLoginStr){
                                    if Telnet.share.sendString(str: "y"){
                                        if Telnet.share.sendData(data: [13]){
                                        }
                                    }
                                }

                                if Telnet.share.sendData(data: [13]){
                                    if Telnet.share.sendData(data: telnetDic["up"]!){
                                        if Telnet.share.sendData(data: telnetDic["right"]!){
                                            saveFavorite(str: Telnet.share.nowStr)
                                        }
                                    }
                                }
*/
                            }
                        }
                    }
                }


            }
        }else{
            DLog(message: "connect fail")
        }
    }

    func saveFavorite(str:String, index:Int){
        print("save")
        let from = 1 + (index - 1) * 20
        let end = 20 + (index - 1) * 20
        for i in from...end{
            if let range = str.range(of: "\(i)   \u{08}\u{08}\u{1B}ˇ\u{1B}\u{1B}"){
                let startIndex = range.upperBound
                let tempStr = str[startIndex..<str.endIndex]
                if let range2 = tempStr.range(of: " "){
                    let endIndex = range2.lowerBound
                    var favoriteStr = String(str[startIndex..<endIndex])
                    favoriteStr = favoriteStr.replacingOccurrences(of: "ˇ", with: "")
                    favoriteArrKey.append(favoriteStr)
                }
            }else if let range = str.range(of: "\(i)   \u{1B}"){
                let startIndex = range.upperBound
                let tempStr = str[startIndex..<str.endIndex]
                if let range2 = tempStr.range(of: " "){
                    let endIndex = range2.lowerBound
                    var favoriteStr = String(str[startIndex..<endIndex])
                    favoriteStr = favoriteStr.replacingOccurrences(of: "ˇ", with: "")
                    favoriteArrKey.append(favoriteStr)
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
