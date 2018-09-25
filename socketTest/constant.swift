//
//  constant.swift
//  socketTest
//
//  Created by Jim Chuang on 2018/9/13.
//  Copyright © 2018年 nhr. All rights reserved.
//

import Foundation

let address1 = "140.112.172.1"
let address2 = "140.112.172.2"
let address5 = "140.112.172.5"
let address11 = "140.112.172.11"

let port:Int32 = 23
let saveKey = "pref_key_save"
let saveKeyUtf8 = "pref_key_save_utf8"

let READ_EMPTY = "read_EMPTY"
let repeatLoginStr = "重複登入"
let pressAnyKeyStr = "請按任意鍵繼續"
let get100percentStr = "頁 (100%)"
let reviewPageStr = "瀏覽 第"
let Board_Delete_Str = "本文已"
let Board_Main_Text = "※\u{1B} 發信站: 批踢踢實業坊(ptt.cc),"
let Board_Sub_Text = "\u{1B}: "

//SubTableView
let pushKeyStr = "\u{1B}推 \u{1B}"
let bullShitKeyStr = "\u{1B}噓 \u{1B}"
let arrowKeyStr = "\u{1B}→\u{1B} \u{1B}"
let nameEndKeyStr = "\u{1B}: "
let nameEndKeyStr2 = "\u{1B}\u{1B}"
let endKeyStr = "\u{1B}"

var favoriteArrKey = Array<String>()
var favoriteArrValue = Array<String>()
var selectIndex = 0
var selectSubjectStr = ""

//{1B}推 \u{1B}wet00428\u{1B}: 夜店                                     \u{1B}
//{1B}推 \u{1B}STi2011\u{1B}: 酒店       \u{1B}
//\u{1B}→\u{1B} \u{1B}chao0210\u{1B}: 八卦版                                \u{1B}
//{1B}噓 \u{1B}pieceiori\u{1B}: 幹! 乾脆吸它自己的懶叫好了            \u{1B}
