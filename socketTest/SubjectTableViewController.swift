//
//  SubjectTableViewController.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/9/21.
//  Copyright © 2018年 nhr. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController,TelnetDelegate {

    var totalText = ""
    var myTextArr = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rightSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(direct(sender:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)

        let doubleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(whenDTap))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.backgroundColor = .black

    }

    override func viewDidAppear(_ animated: Bool) {
        Telnet.share.delegate = self
        let searchSubject = selectSubjectStr
        if Telnet.share.sendString(str: "/"){
            if Telnet.share.sendString(str: searchSubject){
                if Telnet.share.sendData(data: [13]){
                    if Telnet.share.sendData(data: telnetDic["right"]!){
//        if Telnet.share.sendString(str: selectSubjectStr){
//            if Telnet.share.sendData(data: [13]){
//                if Telnet.share.sendData(data: telnetDic["right"]!){
//                    if true{
                        // 讀取所有分頁存至TotalText
                        refreshLabel(str: Telnet.share.nowStr)
                        while !Telnet.share.nowStr.contains(get100percentStr){
                            addRefreshLabel()
                        }

                        // 分割原文
                        var mainText = getMainText(str: totalText)
                        mainText = removeDash(str: mainText)
                        myTextArr.append(mainText)

                        // 分割推文
                        var subText = totalText
                        while subText.contains(pushKeyStr) || subText.contains(bullShitKeyStr) || subText.contains(arrowKeyStr){

                            // 判斷優先權
                            var select = 0
                            var rangeNum = 999999
                            if let range = subText.range(of: pushKeyStr){
                                let nowNum = subText.distance(from: subText.startIndex, to: range.upperBound)
                                rangeNum = nowNum
                                select = 1
                            }

                            if let range = subText.range(of: bullShitKeyStr){
                                let nowNum = subText.distance(from: subText.startIndex, to: range.upperBound)
                                if nowNum < rangeNum{
                                    rangeNum = nowNum
                                    select = 2
                                }
                            }

                            if let range = subText.range(of: arrowKeyStr){
                                let nowNum = subText.distance(from: subText.startIndex, to: range.upperBound)
                                if nowNum < rangeNum{
                                    rangeNum = nowNum
                                    select = 3
                                }
                            }

                            var keyWord = ""
                            var title = ""
                            var name = ""
                            var text = ""

                            switch select{
                            case 1:
                                keyWord = pushKeyStr
                                title = "推"
                            case 2:
                                keyWord = bullShitKeyStr
                                title = "噓"
                            case 3:
                                keyWord = arrowKeyStr
                                title = "→"
                            default:
                                keyWord = pushKeyStr
                            }

                            // 加入評價
                            if let range = subText.range(of: keyWord){
                                var spareStr = String(subText[range.upperBound..<subText.endIndex])

                                // name
                                if let rangeName = spareStr.range(of: nameEndKeyStr){
                                    name = String(spareStr[spareStr.startIndex..<rangeName.lowerBound])
                                    spareStr = String(spareStr[rangeName.upperBound..<spareStr.endIndex])
                                }else if let rangeName = spareStr.range(of: nameEndKeyStr2){
                                    name = String(spareStr[spareStr.startIndex..<rangeName.lowerBound])
                                    spareStr = String(spareStr[rangeName.upperBound..<spareStr.endIndex])
                                }

                                // text
                                if let rangeText = spareStr.range(of: endKeyStr){
                                    text = String(spareStr[spareStr.startIndex..<rangeText.lowerBound])
                                    spareStr = String(spareStr[rangeText.upperBound..<spareStr.endIndex])
                                }

                                // sum
                                let addArrEle = title + " " + name + ":" + text
                                myTextArr.append(addArrEle)

                                // update
                                subText = spareStr
                            }
                        }
                        for i in myTextArr{
                            //print(i)
                        }
                        // 資料重載
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    func refreshLabel(str:String) {
        let removeStr = removeReviewPageString(str: str)
        totalText = removeStr
    }

    func addRefreshLabel(){
        if Telnet.share.sendData(data: telnetDic["right"]!){
            let addStr = removeReviewPageString(str: Telnet.share.nowStr)
            totalText += addStr
        }
    }

    func getMainText(str:String) -> String{

        var myStr = str
        if let range = myStr.range(of: Board_Main_Text){
            let endIndex = range.lowerBound
            myStr = String(str[str.startIndex..<endIndex])
        }
        return myStr
    }


    func removeDash(str:String) -> String{
        let resultStr = str.replacingOccurrences(of: "\u{08}\u{08}─\u{1B}  \u{08}\u{08}─\u{1B}", with: "")
        return resultStr
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


    //MARK: - Gesture
    @objc func direct(sender:UISwipeGestureRecognizer){
        if sender.direction == .right{
            // 搜索模式 -> 兩次跳出
            if Telnet.share.sendData(data: telnetDic["left"]!){
                if Telnet.share.sendData(data: telnetDic["left"]!){
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    @objc func whenDTap(){
        let myView = UIView(frame: self.tableView.frame)
        myView.backgroundColor = .black
        myView.tag = 888
        if let viewTag = self.tableView.viewWithTag(888){
            viewTag.removeFromSuperview()
        }else{
            self.tableView.addSubview(myView)
        }
    }

    //MARK: - Button Click
    @IBAction func backBtnClick(_ sender: UIBarButtonItem) {
        // 搜索模式 -> 兩次跳出
        if Telnet.share.sendData(data: telnetDic["left"]!){
            if Telnet.share.sendData(data: telnetDic["left"]!){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myTextArr.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subject_cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        cell.textLabel?.text = myTextArr[indexPath.row]
        cell.isUserInteractionEnabled = false

        if indexPath.row > 0 {
            cell.textLabel?.font = cell.textLabel?.font.withSize(20)
            cell.textLabel?.text = "\(indexPath.row)F " + myTextArr[indexPath.row]
        }
        switch myTextArr[indexPath.row].first {
        case "推":
            cell.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.4)
        case "噓":
            cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        case "→":
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        default:
            break
        }

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
