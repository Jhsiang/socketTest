//
//  SubjectTableViewController.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/9/21.
//  Copyright © 2018年 nhr. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController,TelnetDelegate {

    var myTextArr = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()

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
                        refreshLabel(str: Telnet.share.nowStr)
                        while !Telnet.share.nowStr.contains(get100percentStr){
                            addRefreshLabel()
                        }
                        var mainText = getMainText(str: myTextArr[0])
                        mainText = removeDash(str: mainText)
                        myTextArr[0] = mainText
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    func refreshLabel(str:String) {
        let removeStr = removeReviewPageString(str: str)
        myTextArr.append(removeStr)
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

    func addRefreshLabel(){
        if Telnet.share.sendData(data: telnetDic["right"]!){
            let addStr = removeReviewPageString(str: Telnet.share.nowStr)
            myTextArr[0] = myTextArr[0] + addStr
        }
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
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = .black
        cell.textLabel?.text = myTextArr[indexPath.row]
        cell.isUserInteractionEnabled = false

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
