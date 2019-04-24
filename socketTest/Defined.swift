//
//  Defined.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/8/2.
//  Copyright © 2018年 nhr. All rights reserved.
//

import Foundation

//extension String{
//    func substring(from index: Int) -> String {
//        if self.characters.count > index {
//            let startIndex = self.index(self.startIndex, offsetBy: index)
//            let subString = self[startIndex..<self.endIndex]
//
//            return String(subString)
//        } else {
//            return self
//        }
//    }
//}

func DLog<T> (message: T, fileName: String = #file, funcName: String = #function, lineNum: Int = #line) {

    #if DEBUG

    let file = (fileName as NSString).lastPathComponent

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
    let sendDate = Date()
    let timeStr = dateFormatter.string(from: sendDate)

    print("-\(timeStr) \(file) \(funcName)-[\(lineNum)]: \(message)")

    #endif

}

func convertStrToUInt8Arr(str:String) -> [UInt8]{
    return Array(str.utf8)
}

func convertUInt8ArrToStr(uint8:[UInt8]) -> String? {

    var myUInt8 = uint8
    //DLog(message: "before data count = \(myUInt8.count)")
    let cfEnc = CFStringEncodings.big5
    let nsEnc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
    let big5encoding = String.Encoding(rawValue: nsEnc) // String.Encoding
    while myUInt8.count > 0 {
        if let str = String(bytes: myUInt8, encoding: .utf8){
            //DLog(message: "after data count = \(myUInt8.count)")
            return str
        }else{
            myUInt8.removeLast()
        }
    }

    DLog(message: "after data count = \(myUInt8.count)")
    return nil

}

func converUInt8ArrToStr2(unit8:[UInt8]) -> String?{
    var uint8 = unit8
    var s = 0
    var e = 0
    var res = ""
    while e <= uint8.count {
        let str = String(bytes: unit8[s..<e], encoding: .utf8)
        if str == nil{
            if e - s > 11{
                s = e
            }
            e += 1
        }else{
            res += str!
            s = e
            e += 1
        }
    }
    return res
}

public struct EscapeCharacters {
    static let CSI: String = "["
    static let SGREnd = "m"
}

struct AttributeKeys {
    static let name = "attributeName"
    static let value = "attributeValue"
    static let range = "range"
    static let code = "code"
    static let location = "location"
}

func escapeCodesForString(escapedString: String, cleanString: inout String?) -> [[String: Any]] {
    let aString = escapedString as NSString
    if (aString == "") {
        return []
    }

    if (aString.length <= EscapeCharacters.CSI.count) {
        return []
    }

    var formatCodes = [[String: Any]]()

    var aStringLength = aString.length
    var coveredLength = 0

    var searchRange = NSMakeRange(0, aStringLength)
    var sequenceRange: NSRange
    var thisCoveredLength: Int = 0
    var searchStart: Int = 0

    repeat
    {
        sequenceRange = aString.range(of: EscapeCharacters.CSI, options: .literal, range: searchRange) //find literal

        if (sequenceRange.location != NSNotFound) {

            thisCoveredLength = sequenceRange.location - searchRange.location
            coveredLength += thisCoveredLength

            formatCodes += codesForSequence(sequenceRange: &sequenceRange, string: aString).map { code in
                [AttributeKeys.code: code, AttributeKeys.location: coveredLength]
            }

            if (thisCoveredLength > 0) {
                cleanString = cleanString?.appending(aString.substring(with: NSMakeRange(searchRange.location, thisCoveredLength)))
            }

            searchStart = NSMaxRange(sequenceRange)
            searchRange = NSMakeRange(searchStart, aStringLength - searchStart)
        }
    } while(sequenceRange.location != NSNotFound)

    if (searchRange.length > 0) {
        cleanString = cleanString?.appending(aString.substring(with: searchRange))
    }

    return formatCodes
}

func codesForSequence(sequenceRange: inout NSRange, string: NSString) -> [Int] {
    var codes = [Int]()
    var code = 0
    var lengthAddition = 1
    var thisIndex: Int

    while(true)
    {
        thisIndex = (NSMaxRange(sequenceRange) + lengthAddition - 1)

        if (thisIndex >= string.length) {
            break
        }

        var c: Int = Int(string.character(at: thisIndex))

        if ((48 <= c) && (c <= 57))
        {
            let digit: Int = c - 48
            code = (code == 48) ? digit : code * 10 + digit
        }

        if (c == 109)
        {
            codes.append(code)
            break
        } else if ((64 <= c) && (c <= 126)) {
            codes.removeAll(keepingCapacity: false)
            break
        } else if (c == 59) {
            codes.append(code)
            code = 0
        }

        lengthAddition += 1
    }

    sequenceRange.length += lengthAddition

    return codes
}









//http://webcache.googleusercontent.com/search?q=cache:Caql2XRSS2UJ:hitbbs.blogspot.com/2011/04/hit-bbs_22.html&hl=zh-TW&gl=tw&strip=1&vwsrc=0
let telnetDic:[String:[UInt8]] = [
    "A":[65],
    "B":[66],
    "C":[67],
    "D":[68],
    "E":[69],
    "F":[70],
    "G":[71],
    "H":[72],
    "I":[73],
    "J":[74],
    "K":[75],
    "L":[76],
    "M":[77],
    "N":[78],
    "O":[79],
    "P":[80],
    "Q":[81],
    "R":[82],
    "S":[83],
    "T":[84],
    "U":[85],
    "V":[86],
    "W":[87],
    "X":[88],
    "Y":[89],
    "Z":[90],
    "a":[97],
    "b":[98],
    "c":[99],
    "d":[100],
    "e":[101],
    "f":[102],
    "g":[103],
    "h":[104],
    "i":[105],
    "j":[106],
    "k":[107],
    "l":[108],
    "m":[109],
    "n":[110],
    "o":[111],
    "p":[112],
    "q":[113],
    "r":[114],
    "s":[115],
    "t":[116],
    "u":[117],
    "v":[118],
    "w":[119],
    "x":[120],
    "y":[121],
    "z":[122],
    "0":[48],
    "1":[49],//0x31
    "2":[50],
    "3":[51],
    "4":[52],//0x34
    "5":[53],//0x35
    "6":[54],//0x36
    "7":[55],
    "8":[56],
    "9":[57],
    ",":[44],
    ".":[46],
    "~":[0x7E],
    "up":[0x1B,0x5B,0x41],
    "down":[0x1B,0x5B,0x42],
    "right":[0x1B,0x5B,0x43],
    "left":[0x1B,0x5B,0x44],
    "pageUp":[0x1B,0x5B,0x35,0x7E],
    "pageDown":[0x1B,0x5B,0x36,0x7E],
    "home":[0x1B,0x5B,0x31,0x7E],
    "end":[0x1B,0x5B,0x34,0x7E],
    "enter":[13],
    "backspace":[0x08],
    "fastrefreshpush":[0x1B,0x5B,0x44,0x1B,0x5B,0x43,0x1B,0x5B,0x34,0x7E]
]

/*
 快速更新推文的方法
 但同一個控制字元「^[[D^[[C^[[4~」


 keyChain 儲存帳密
 https://cg2010studio.com/2014/08/29/ios-%E5%B0%87%E5%AF%86%E7%A2%BC%E5%84%B2%E5%AD%98%E6%96%BCkeychain/
 */


/*
 這是 Google 對 http://hitbbs.blogspot.com/2011/04/hit-bbs_22.html 的快取。 這是該網頁於 2018年12月28日 12:32:05 GMT 顯示時的快照。 在此期間，目前網頁可能已經變更。 瞭解更多資訊.
 完整版純文字版檢視原始碼
 提示：如要在這個網頁上快速尋找您所搜尋的字詞，請按下 Ctrl+F 鍵或 ⌘-F 鍵 (Mac)，然後使用尋找列進行搜尋。
 Hit BBS
 在iPhone上盡情地打逼逼、分享心情、回應文章、推文噓文、跟網友鄉民同樂吧。

 繁體中文(Traditional Chinese)
 简体中文(Simplified Chinese)
 2011-04-22
 開發Hit BBS時所運用的技術
 這一篇要記錄在iOS平台上開發Hit BBS時，所做的考量以及使用的技術。


 １．TELNET需要一條雙向的TCP連線。

 iOS有BSD Sockets，但那實在太基本太低階了，而且是一般的C介面，跟上層Cocoa Touch(UIKit, Foundation Kit)之Objective-C介面是不同世界的東西，現在都什麼時代了，總該有更高階更方便的介面吧。

 CFSocket、CFStream，看起來像是把BSD Sockets包上薄薄的一層外衣，用C來實作物件導向的概念，加入一些與run-loop的整合，但還是很低階。

 CFNetwork(CFHTTP, CFFTP)，在CFSocket、CFStream之上的軟體框架，但主要用在HTTP與FTP上，以CF(core foundation)字眼開頭，就讓我感覺還是不夠高階方便使用，另外，雖然好像可以自己動手寫，支援別的protocol，但我沒找到像樣的文件說明，話說回來，我也不想寫這麼基本的東西。

 NSNetServices、CFNetServices，這是跟Bonjour有關的，不是我要的。

 URL Loading System，顧名思義，這是指定URL然後取回資料，支援HTTP與FTP，還有本地端的file://，也就是說，不是我要的。





 看了一大堆文件，到此覺得很灰心，心想：不會吧，這是iPhone耶、這是Apple耶，連個像樣的TCP網路連線API都沒有嗎？我需要的是能夠建立TCP連線，讀寫時不可blocking，必須是asynchronous的，好吧，只好上網搜尋了，找啊找，終於找到適合我用的了。

 就是這個CocoaAsyncSocket，光看名字覺得是這個了，以CFStream與CFSocket為基礎，最早是由Dustin Voss在2003年開發出來的（什麼？那為什麼到現在iOS上沒有官方版的相對應的API呢？），現在由Deusty LLC與社群共同維護開發，所以有bug會有人修，而且授權採用Public Domain License，也就是說我可以自由地使用不怕被告，感謝啊。

 專案網站在此，可在此下載原始碼，裡頭也有非常棒的文件說明，包括socket的基礎介紹、API的說明與用法以及常犯錯誤、如何把它放進Xcode專案裡、等等。


 ２．TELNET protocol，不消說，這當然是要會的。主要有下列這些：
 RFC0854 Telnet Protocol Specification
 RFC0855 Telnet Option Specifications
 RFC1091 Telnet terminal-type option
 RFC1073 Telnet window size option
 RFC0858 Telnet Suppress Go Ahead Option
 RFC0857 Telnet Echo Option
 RFC0856 Telnet Binary Transmission

 可到RFC Editor下載，另外還有些資料加密傳輸的額外選項，但bbs通常不支援，也就不需理會，最重要的是854，約17頁，其他的都是些額外選項，每份不到5頁，讀spec有個困難的地方是，其年代久遠，當時考慮的狀況與現今不同，所以常常搞不懂為什麼spec裡訂了些看起來莫名其妙的規則，當初在70、80年代，有各種不同的終端機與主機，為了有個標準，所以才有了TELNET protocol。可以參考其他網路上的文件，例如這裡、這裡、這裡。

 TELNET protocol的核心重點有三個：Network Virtual Terminal(NVT)、Options and Option Negotiation、Symmetric Operation。


 ３．TELNET protocol看懂後，我們需要一個parser來解析server端送來的資料。

 把server送來的telnet封包解析，裡面會有：TELNET定義的控制指令，例如控制游標、選項協調等等；ANSI Escape Sequence（前景色、背景色、閃爍字、控制游標指令、其他）；資料（英文、繁體中文、簡體中文）與編碼（Big5、Unicode補完計畫、GB、GBK）；其中要注意雙色的中文字。

 寫parser要注意，遇到看不懂的東西時，要能容忍錯誤，繼續往下解析，server也有可能會送出錯誤的資料。

 輔助工具：可用抓封包的軟體Ethereal或是WireShark，來抓telnet封包，解析內容幫助了解。


 ４．關於編碼，需要支援Big5、Unicode補完計畫、GB、GBK。

 其中繁體中文的編碼表，可到這裡下載。
 簡體中文的編碼表，可到這裡找找。
 編碼表就是big5、gb、unicode互轉的表，沒什麼特別的.


 ５．關於ANSI Escape sequence。

 老實說，看維基百科的說明，應該就能幾乎涵蓋所有的可能性，但實際情況誰知道呢，網路上還可以找到更多的escape sequence，但是，我找不到一台server可以測試啊。


 ６．文字模式Text Mode。

 iPhone就是繪圖模式，要自己手動打造文字模式出來，意思是說，半形的英文字、數字、標點符號都佔一格的寬度，全型的中文字佔兩格寬度。如果直接用NSString的API去畫一整串字，空白(0x20)與一些標點符號的寬度會依照狀況不同而改變（真是混蛋啊），所以要自己手動畫。

 另外，bbs常用一些方塊或線條來畫圖(ASCII Art)，但若用iPhone裡面的中文字型，這些方塊線條畫出來會怪怪的，不好看，所以要另外處理。


 ７．使用者輸入。

 首先要知道鍵盤上的各個鍵（Enter、Delete、Page Up、Ctrl-X、Up、等等），會送出什麼樣的碼，各支bbs clients皆有所不同，例如Backspace，PCMan會送出0x7f，但KKMan會送出0x08，例如Up（方向鍵 上），PCMan會送出0x1b 0x4f 0x41，但NetTerm會送出0x1b 0x5b 0x41。基本上server端應該都能吃。

 一般文字輸入時為unicode，送出時要轉成適當的編碼。


 ８．在iPhone上要儲存密碼時，要用KeyChain加密儲存。

 不過KeyChain這一套API實在有夠難用，還是用scifihifi-iphone吧。


 ９．其他，有很多哩哩摳摳的小地方，大多是對UIKit的不了解才多花了很多冤枉時間。譬如畫面旋轉的處理、判斷URL開啟瀏覽器、等等。


 １０．分享功能，分享文章內容或網址到社群網站上，例如臉書或噗浪。

 可使用這套ShareKit，已經有支援Facebook、Twitter、Delicious、Google Reader、Read It Later等等，不過尚未支援噗浪，我自己寫了，可到這裡下載。


 １１．參考的bbs clients。
 Posted by yehnan at 2:01 PM
 Email ThisBlogThis!Share to TwitterShare to FacebookShare to Pinterest
 Labels: 參考資料
 4 comments:
 吸血鬼日行January 17, 2013 at 9:51 AM
 CocoaAsyncSocket現在已經搬到Github上囉~
 https://github.com/robbiehanson/CocoaAsyncSocket

 ReplyDelete
 Replies
 yehnanJanuary 17, 2013 at 9:55 AM
 感謝，已修正。

 Delete
 Replies
 Reply
 Reply
 JohnnyJuly 16, 2013 at 12:24 PM
 最近也想開發個client端的telnet app來上ptt...
 但是光是了解tcp socket的運作方式我就頭昏了..
 解析傳回來的封包也是都看不懂..

 目前只用GCDAsycSocket連線成功而已
 還有傳送帳號給伺服器端
 接下來就不知道怎麼傳送密碼了..囧..

 ReplyDelete
 Replies
 yehnanJuly 16, 2013 at 1:15 PM
 使用CocoaAsyncSocket的話，就只需處理TELNET protocol即可，不需要處理TCP的封包內容。要看的是TELNET protocol的RFC。

 傳送密碼跟重送帳號是一樣的，TELNET並沒有加密連線。


 Delete
 Replies
 Reply
 Reply
 Add comment
 Load more...
 Newer Post Older Post Home
 Subscribe to: Post Comments (Atom)
 1 - Hit BBS的首頁
 2 - 基本操作
 3 - 設定
 4 - 建議新功能
 5 - 回報錯誤
 6 - 常見問題
 7 - 聯絡作者
 站內搜尋
 參考資料
 打BBS的軟體
 測試網路連線的品質
 BBS色彩配置範例
 開發Hit BBS時所運用的技術
 舊資料
 基本操作（1.0版）
 Powered by Blogger.
 */
