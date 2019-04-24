//
//  testViewController.swift
//  socketTest
//
//  Created by Jim Chuang on 2019/1/29.
//  Copyright © 2019 nhr. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        mySocket = MySocket()
        DLog(message: mySocket?.connectStatus)
        mySocket?.connect()
        DLog(message: mySocket?.connectStatus)
        mySocket?.send()
    }
    



}
