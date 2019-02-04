//
//  API.swift
//  iPartner
//
//  Created by Konstantin Mishukov on 30/01/2019.
//  Copyright © 2019 Konstantin Mishukov. All rights reserved.
//

import Foundation
import SwiftyJSON

// Результирующие сообщения
public enum Result: String {
    case Success
    case ErrorAPI
    case ErrorHTTP
    case ErrorUnkwn
}

// Возвращающийся объект
public struct apiReturn {
    public var data: Data?
    public var json: JSON?
    public var error: NSError?
    public var result: Result?
}

class API {
    static let token = "Q2x5jc7-Wk-74IH4pV" // Mishukov Konstantin - kkmishukov@gmail.com
    
    static let url = "https://bnet.i-partner.ru/testAPI/"
    static var session = "" 
    
    static func networkRequest(parameters: [String:String], completion:  @escaping (apiReturn) -> () ) -> () {
        var recieved = apiReturn()
        HTTPRequest.request(API.url, token: API.token, parameters: parameters) { (data,response,error) in
            if let data = data, let json = try? JSON(data:data) {
                switch json["status"] {
                    case 1: recieved.result = .Success
                    case 0: recieved.result = .ErrorAPI
                    default: recieved.result = .ErrorUnkwn
                }
                recieved.json = json
                recieved.data = data
                completion(recieved)
                return
            } else if error == nil {
                recieved.data = data
                recieved.result = .ErrorUnkwn
                completion(recieved)
                return
            }
            recieved.result = .ErrorHTTP
            recieved.error = error as NSError?
            completion(recieved)
        }
    }
}

class HTTPRequest {
    static func request(_ url: String, token: String, parameters: [String:String], completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) -> () {
        guard let requestURL = URL(string: url) else { print("ERROR: Could not construct URL."); return }
        var request = URLRequest(url: requestURL)
        let param = self.getPostString(params: parameters)
        request.httpBody = param.data(using: .utf8)
        request.addValue(token, forHTTPHeaderField: "token")
        request.httpMethod = "POST"
//        print("Accessing URL: \(request.url!)")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completionHandler(nil,nil,error)
            } else {
//                print("HTTPRequest recieved without errors")
                completionHandler(data,response,nil)
            }
        }
        task.resume()
    }
    
    static func getPostString(params:[String:Any]) -> String {
        var data = [String]()
        for(key, value) in params {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

}
