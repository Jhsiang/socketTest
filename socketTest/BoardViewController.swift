//
//  BoardViewController.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/9/14.
//  Copyright © 2018年 nhr. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController,TelnetDelegate,UIScrollViewDelegate {

    var myScrollView = UIScrollView()
    var myLabel = UILabel()
    var pressAnyKey = false

    @IBOutlet var myView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        myScrollView.frame = CGRect(x: 0, y: 0, width: myView.frame.width, height: myView.frame.height)
        myScrollView.contentSize = CGSize(width: myView.frame.width, height: myView.frame.height)
        myLabel.numberOfLines = 0
        myLabel.textColor = .white
        myLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: myScrollView.contentSize)

        self.myScrollView.addSubview(myLabel)
        myView.addSubview(myScrollView)

        Telnet.share.delegate = self
        let searchSubject = selectSubjectStr
        if Telnet.share.sendString(str: "/"){
            if Telnet.share.sendString(str: searchSubject){
                if Telnet.share.sendData(data: [13]){
                    if Telnet.share.sendData(data: telnetDic["right"]!){
                        refreshLabel(str: Telnet.share.nowStr)
                        while !Telnet.share.nowStr.contains(get100percentStr){
                            addRefreshLabel()
                        }
                    }
                }
            }
        }
    }

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        // 搜索模式 -> 兩次跳出
        if Telnet.share.sendData(data: telnetDic["left"]!){
            if Telnet.share.sendData(data: telnetDic["left"]!){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func refreshLabel(str:String) {
        let removeStr = removeReviewPageString(str: str)
        let mainText = getMainText(str: removeStr)
        myLabel.text = mainText
        myScrollView.contentOffset.x = 0
        myScrollView.contentOffset.y = 0
    }

    func getMainText(str:String) -> String{
        var myStr = str
        if let range = myStr.range(of: Board_Main_Text){
            let endIndex = range.lowerBound
            myStr = String(str[str.startIndex..<endIndex])
        }
        return myStr
    }

    func addRefreshLabel(){
        if Telnet.share.sendData(data: telnetDic["right"]!){
            let height = myScrollView.contentSize.height + myView.frame.height
            myScrollView.contentSize.height = height
            myLabel.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: myScrollView.contentSize)
            let addStr = myLabel.text! + removeReviewPageString(str: Telnet.share.nowStr)
            let mainText = getMainText(str: addStr)
            myLabel.text = mainText
            myLabel.sizeToFit()
            myScrollView.contentSize.height = myLabel.frame.height
        }
        myScrollView.contentOffset.x = 0
        myScrollView.contentOffset.y = 0
    }

    func removeReviewPageString(str:String) -> String{
        var valueStr = str
        if let range = valueStr.range(of: reviewPageStr){
            let endIndex = range.lowerBound
            let tempStr = valueStr[valueStr.startIndex..<endIndex]
            valueStr = String(tempStr)
        }
        return valueStr
    }


    func responseStr(str: String) {
        //DLog(message: str)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
