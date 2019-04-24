//
//  BoardTableViewController.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/9/14.
//  Copyright © 2018年 nhr. All rights reserved.
//

import UIKit

class BoardTableViewController: UITableViewController,TelnetDelegate {

    let startStr = "□\u{1B}"
    let startStrOfRe = "R:  "
    let endStr = "\u{1B}"
    var boardArr = Array<String>()
    var textNumber = ""
    var textNumArr = Array<String>()

    var checkRepeateStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightSwipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(direct(sender:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)

        DLog(message: favoriteArrKey[selectIndex])
        Telnet.share.delegate = self
        let indexStr = String(selectIndex + 1)
        if Telnet.share.sendString(str: indexStr){
            if Telnet.share.sendData(data: [13]){
                if Telnet.share.sendData(data: telnetDic["right"]!){
                    let pressAnyKey = Telnet.share.nowStr.contains(pressAnyKeyStr)
                    if pressAnyKey{
                        if Telnet.share.sendData(data: telnetDic["right"]!){
                            if checkRepeateStr != Telnet.share.nowStr{
                                saveBoard(str: Telnet.share.nowStr)
                                checkRepeateStr = Telnet.share.nowStr
                            }
                        }
                    }else{
                        if checkRepeateStr != Telnet.share.nowStr{
                            saveBoard(str: Telnet.share.nowStr)
                            checkRepeateStr = Telnet.share.nowStr
                        }
                    }
                    Telnet.share.speed = 0.2
                    for _ in 0...3{
                        if Telnet.share.sendData(data: telnetDic["pageUp"]!){
                            if checkRepeateStr != Telnet.share.nowStr{
                                saveBoard(str: Telnet.share.nowStr)
                                checkRepeateStr = Telnet.share.nowStr
                            }
                        }
                    }
                    Telnet.share.speed = 0.2
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .black
        Telnet.share.delegate = self
    }

    func responseStr(str: String) {
       //DLog(message: str)
    }

    func saveBoard2(str:String){
        var valueStr = str
//        valueStr = valueStr.replacingOccurrences(of: "\u{1B}", with: "")
//        valueStr = valueStr.replacingOccurrences(of: "\u{08}", with: "")
//        valueStr = valueStr.replacingOccurrences(of: "\r", with: "")
//        valueStr = valueStr.replacingOccurrences(of: "\n", with: "")

        while valueStr.contains("□") || valueStr.contains("R:") || valueStr.contains("●"){
            let mySubject = Subject()
            if let range = valueStr.range(of: Board_Get_People){
                let startIndex = range.upperBound
                valueStr = String(valueStr.suffix(from: startIndex))
                if let range2 = valueStr.range(of: "\u{1B}\u{1B}"){
                    let startIndex2 = range2.upperBound
                    valueStr = String(valueStr.suffix(from: startIndex2))
                    var texNumStr = String(valueStr.prefix(5))
                    valueStr = String(valueStr.suffix(6))
                    texNumStr = texNumStr.replacingOccurrences(of: " ", with: "")
                    mySubject.number = texNumStr
                }
            }
        }
    }

    func saveBoard(str:String){
        var valueStr = str
        var tempArr = Array<String>()
        var removeStr = str.replacingOccurrences(of: "\u{1B}", with: "")
        removeStr = removeStr.replacingOccurrences(of: "\u{08}", with: "")
        removeStr = removeStr.replacingOccurrences(of: "\r", with: "")
        removeStr = removeStr.replacingOccurrences(of: "\n", with: "")
        //print(removeStr)

        var realStr = str
        realStr = realStr.replacingOccurrences(of: "\u{1B}", with: "\\u{1B}")
        realStr = realStr.replacingOccurrences(of: "\u{08}", with: "\\u{08}")
        //print(realStr)

        // 記錄首篇文章代號
        if textNumber.count == 0 {
            if let range = removeStr.range(of: "●"){
                let stratIndex = range.upperBound
                removeStr = String(removeStr.suffix(from: stratIndex))
                textNumber = String(removeStr.prefix(5))
                textNumber = textNumber.replacingOccurrences(of: " ", with: "")
            }
        }


        while valueStr.contains(startStr) || valueStr.contains(startStrOfRe){

            // 判斷優先權
            var selectIndex = 0
            var rangeNum = 999999
            if let range = valueStr.range(of: startStr){
                let nowNum = valueStr.distance(from: valueStr.startIndex, to: range.upperBound)
                rangeNum = nowNum
                selectIndex = 1
            }

            if let range = valueStr.range(of: startStrOfRe){
                let nowNum = valueStr.distance(from: valueStr.startIndex, to: range.upperBound)
                if nowNum < rangeNum{
                    rangeNum = nowNum
                    selectIndex = 2
                }
            }

            // 判斷新主題關鍵字
            if selectIndex == 1{
                if let range = valueStr.range(of: startStr){

                    // 取得起啟關鍵字字尾
                    let startIndex = range.upperBound

                    // 從起始關鍵字字尾開始排列
                    let tempStr = valueStr[startIndex..<valueStr.endIndex]

                    // 判斷結束的關鍵字
                    if let range2 = tempStr.range(of: endStr){

                        // 取得結束關鍵字字頭
                        let endIndex = range2.lowerBound

                        // 獲取正確的關鍵字(起啟尾 取到 結束頭)
                        var boardStr = String(valueStr[startIndex..<endIndex])

                        // 移除主題開頭為空格(截取錯誤導致)
                        let spaceChar:Character = " "
                        if boardStr.first == spaceChar{
                            boardStr.removeFirst()
                        }

                        /*
                        // 篩掉刪除
                        if !boardStr.contains(Board_Delete_Str) && boardStr.count != 0 {
                            tempArr.append(boardStr)
                        }
                        */

                        if boardStr.count != 0 {
                            tempArr.append(boardStr)
                        }
                    }

                    // 剩餘字串重新判斷
                    valueStr = String(tempStr)

                }
            }else if selectIndex == 2{
                // 判斷回履主題關健字
                if let range = valueStr.range(of: startStrOfRe){

                    // 取得起啟關鍵字字尾
                    let startIndex = range.upperBound

                    // 從起始關鍵字字尾開始排列
                    let tempStr = valueStr[startIndex..<valueStr.endIndex]

                    // 判斷結束的關鍵字
                    if let range2 = tempStr.range(of: endStr){

                        // 取得結束關鍵字字頭
                        let endIndex = range2.lowerBound

                        // 獲取正確的關鍵字(起啟尾 取到 結束頭)
                        var boardStr = String(valueStr[startIndex..<endIndex])

                        // 移除主題開頭為空格(截取錯誤導致)
                        let spaceChar:Character = " "
                        if boardStr.first == spaceChar{
                            boardStr.removeFirst()
                        }

                        /*B
                        // 篩掉刪除
                        if !boardStr.contains(Board_Delete_Str) && boardStr.count != 0 {
                            tempArr.append(boardStr)
                        }
                        */

                        if boardStr.count != 0 {
                            tempArr.append(boardStr)
                        }
                    }

                    // 剩餘字串重新判斷
                    valueStr = String(tempStr)
                }
            }
        }

        // 原始資料由上往下(上舊下新)，反轉為上新下舊後加入Array
        tempArr.reverse()
        for i in tempArr{
            boardArr.append(i)
        }

        // 儲存文章代號
        if boardArr.count >= 1{
            textNumArr = Array<String>()
            for i in 0...boardArr.count - 1{
                if let textInt = Int(textNumber){
                    textNumArr.append(String(textInt - i))
                }
            }
        }


        self.tableView.reloadData()
        print("board count = \(boardArr.count)")

    }

    //MARK: - Btn Click
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        goBack()
    }

    //MARK: - gesture
    @objc func direct(sender:UISwipeGestureRecognizer){
        if sender.direction == .right{
            goBack()
        }
    }

    func goBack(){
        if Telnet.share.sendData(data: telnetDic["end"]!){
            if Telnet.share.sendData(data: telnetDic["left"]!){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return boardArr.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "board_cell", for: indexPath)
        cell.textLabel?.text = "\(boardArr[indexPath.row])"
        cell.textLabel?.textColor = .white

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectSubjectStr = boardArr[indexPath.row]

        // Disable 刪除文
        if !selectSubjectStr.contains(Board_Delete_Str){
            self.performSegue(withIdentifier: "seque_board_to_subject", sender: nil)
        }

    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let currY = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height
        let myFrameHight = scrollView.frame.size.height

        if currY + myFrameHight >= contentSize {
            Telnet.share.speed = 0.2
            for _ in 0...3{
                if Telnet.share.sendData(data: telnetDic["pageUp"]!){
                    if checkRepeateStr != Telnet.share.nowStr{
                        saveBoard(str: Telnet.share.nowStr)
                        checkRepeateStr = Telnet.share.nowStr
                    }
                }
            }
            Telnet.share.speed = 0.2
        }
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
