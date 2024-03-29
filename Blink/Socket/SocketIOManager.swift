//
//  SocketIOManager.swift
//  Blink
//
//  Created by Chaewon on 2/14/24.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    var manager = SocketManager(socketURL: URL(string: APIKey.baseURL)!, config: [/*.log(true),*/ .compress])
    var socket: SocketIOClient!
    
    //소켓 연결 상태
    var isOpen = false
    var isBreak = false
    
    override init() {
        super.init()
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("\nSOCKET CONNECTED", data, ack)
        }
        socket.on(clientEvent: .disconnect) { data, ack in
            print("\nSOCKET DISCONNECTED", data, ack)
        }
    }
    
    // MARK: 소켓 연결
    func establishConnection(channelID: Int) {
        
        self.closeConnection() // 혹시 연결된 소켓있으면 제거
        socket = manager.socket(forNamespace: "/ws-channel-\(channelID)")
        socket.connect()
        print("소켓 연결")
        self.isOpen = true
        
    }
    
    // MARK: 소켓 연결 해제
    func closeConnection() {
        
        socket.disconnect()
        socket.removeAllHandlers()

        print("소켓 연결 종료")
        self.isOpen = false
        
    }
    
    func pauseConnect() {
        if isOpen && !isBreak {
            closeConnection()
            isBreak = true
        }
    }
    
    func reconnect() {
        if isBreak {
            socket.connect()
            isBreak = false
        }
    }
    
    // MARK: 소켓 데이터 RECEIVE
    func receiveMessage<T: Decodable>(type: T.Type, completion: @escaping (T) -> Void) {
        
        socket.on("channel") { data, ack in
            print("CHANNEL RECEIVED", data, ack)
            
            guard let data = data.first else { return }
            
            if let response: T = try? self.convertData(data: data) {
                completion(response)
            }
        }
    }
    
    func convertData<T: Decodable>(data: Any) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let decoder = JSONDecoder()
        
        return try decoder.decode(T.self, from: jsonData)
    }
    
}
