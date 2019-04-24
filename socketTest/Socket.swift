//
//  Socket.swift
//  socketTest
//
//  Created by Jim Chuang on 2019/1/29.
//  Copyright © 2019 nhr. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
/*
public class adeleg: NSObject, StreamDelegate {
    public var inputStream: InputStream!
    public var outputStream: OutputStream!
    public func stream(stream: Stream, handleEvent eventCode: NSStreamEvent) {
        print("stream event")
    }
}
*/
var mySocket: MySocket?
let PACKET = 4

public class MySocket: NSObject , GCDAsyncSocketDelegate {
    var mSocket: GCDAsyncSocket!
    var connectStatus = 0

    override init() {
        super.init()
        mSocket = GCDAsyncSocket()
        mSocket.delegate = self
        mSocket.delegateQueue = DispatchQueue.main
    }

    public func send(){
        let cmd:UInt8 = 2
        let myuid:UInt32 = 1000
        var uid = myuid.bigEndian
        let str = UIDevice.current.identifierForVendor?.uuidString
        let content = str?.data(using: String.Encoding.utf8)
        var d = Data()
        d.append(cmd)
        d.append(Data(bytes: &uid, count: MemoryLayout.size(ofValue: uid)))
        d.append(content!)
        let contentlen = UInt32(d.count)
        var len = contentlen.bigEndian
        d.insert(contentsOf: Data(bytes: &len, count: MemoryLayout.size(ofValue: len)), at: 0)
        mSocket.write(d, withTimeout: TimeInterval(1000), tag: 0)
    }

    public func connect() {
        do {
            connectStatus = 0
            try mSocket.connect(toHost: address1, onPort: 23, withTimeout: TimeInterval(1000))
        } catch {
            print("conncet error")
        }

    }
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        //parse_data(data: data)

        // new constructor:
        let data = [UInt8](data)

        // …or old style through pointers:
//        let array = data.withUnsafeBytes {
//            [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
//        }

        if let str = convertUInt8ArrToStr(uint8: data){
            var noAnsiStr:String? = ""
            let escStr = escapeCodesForString(escapedString: str, cleanString: &noAnsiStr)
            DLog(message: escStr)
        }else{
            DLog(message: "No")
        }
        sock.readData(withTimeout: -1, tag: 0)
    }

    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        sock.readData(withTimeout: -1, tag: 0)
        print("success")
    }

    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("disconnect")
    }

    public func parse_data(data:Data){
        let lenByte = data.subdata(in: 0..<PACKET )
        let contentLength = Int(UInt32(bigEndian: lenByte.withUnsafeBytes { $0.pointee }))
        let contentByte   = data.subdata(in: PACKET..<contentLength+PACKET)
        switch contentByte[0] {
        case 1:
            let flagByte = contentByte[1]
            let uidByte  = contentByte.subdata(in: 2..<contentByte.count)
            print(flagByte, UInt32(bigEndian: uidByte.withUnsafeBytes { $0.pointee }))
            break;
        case 2:
            let flagByte = contentByte[1]
            print(flagByte)
            break;
        default:
            print("unknow cmd")
        }
        if contentLength+PACKET < data.count {
            parse_data(data: data.subdata(in: contentLength+PACKET..<data.count))
        }
    }

}


class TcpSocketConnection: NSObject, GCDAsyncSocketDelegate {
/*
    let tcpSocket: GCDAsyncSocket?

    init(host: String, port: UInt16) {
        self.tcpSocket = GCDAsyncSocket(delegate: self, delegateQueue: nil)
        do {
            try tcpSocket?.connect(toHost: host, onPort: port, withTimeout: 5.0)
        } catch let error {
            print("Cannot open socket to \(host):\(port): \(error)")
        }
    }

    // Needed by TcpSocketServer to start a connection with an accepted socket
    init(socket: GCDAsyncSocket, node: Node) {
        self.tcpSocket = socket
        self.tcpSocket?.delegate = self
    }

    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        self.tcpSocket?.readData(toLength: 1024, withTimeout: 60.0)
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        // Process data
        self.tcpSocket?.readData(toLength: 1024, withTimeout: 60.0, tag: 0)
    }

    func send(_ data: Data) {
        self.tcpSocket?.write(data, withTimeout: 10, tag: 0)
    }
*/
}

class SESocketManager: NSObject, GCDAsyncSocketDelegate  {
/*
    var clientSocket:GCDAsyncSocket!
    var connectStatus = 0
    var reconnectionCount = 0

    override init() {
        super.init()
        clientSocket = GCDAsyncSocket()
        clientSocket.delegate = self
        clientSocket.delegateQueue = DispatchQueue.main
        creatSocketToConnectServer()
    }

    // 创建长连接
    func creatSocketToConnectServer() -> Void {
        do {
            connectStatus = 0
            try  clientSocket.connect(toHost: kConnectorHost, onPort: UInt16(kConnectorPort), withTimeout: TimeInterval(timeOut))
        } catch {
            print("conncet error")
        }
    }

    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) -> Void {
        print("Successful")
        socketDidConnectCreatLogin()
        socketDidConnectBeginSendBeat()
    }

    func socketDidConnectCreatLogin() -> Void {
        let login = ["c":"1","p":"ca5542d60da951afeb3a8bc5152211a7","d":"dev_"]
        socketWriteDataToServer(body: login)
        reconnectionCount = 0
        connectStatus = 1
        reconncetStatusHandle?(true)
        delegate?.reconnectionSuccess()
        guard let timer = self.reconnectTimer else {
            return
        }
        timer.invalidate()
    }

    // 长连接建立后 开始发送心跳包
    func socketDidConnectBeginSendBeat() -> Void {
        beatTimer = Timer.scheduledTimer(timeInterval: TimeInterval(heartBeatTimeinterval),
                                         target: self,
                                         selector: #selector(sendBeat),
                                         userInfo: nil,
                                         repeats: true)
        RunLoop.current.add(beatTimer, forMode: RunLoopMode.commonModes)
    }

    // 向服务器发送心跳包
    func sendBeat() {
        let beat = ["c":"3"]
        socketWriteDataToServer(body:beat)
    }

    // 向服务器发送数据
    func socketWriteDataToServer(body: Dictionary<String, Any>) {
        // 1: do   2: try?    3: try!
        guard let data:Data = try? Data(JSONSerialization.data(withJSONObject: body,
                                                               options: JSONSerialization.WritingOptions(rawValue: 1))) else { return }
        print(body)
        clientSocket.write(data, withTimeout: -1, tag: 0)
        clientSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
    }

    // 服务器接收到数据 -->> 接收到数据后抛出去
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) -> Void {
        clientSocket.write(data, withTimeout: -1, tag: 0)
        clientSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
        socketDidReadData(data: data, tag: tag)
    }


    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) -> Void {
        clientSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
    }

    // 断开连接
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) -> Void {
        socketDidDisconectBeginSendReconnect()
    }
 */
}
