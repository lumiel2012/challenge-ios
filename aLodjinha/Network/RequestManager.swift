//
//  RequestManager.swift
//  aLodjinha
//
//  Created by Ricardo Barros on 25/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import Foundation
import UIKit

class RequestManager {
    
    func checkIfValid(fullURL:String) -> Bool {
        
        let url = URL(string: fullURL)
        var result = true
        var _continue = false
        
        let task = URLSession.shared.dataTask(with: url!) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 404) {
                    result = false
                }
                else {
                    result = true
                }
                
                _continue = true
            }
        }
        task.resume()
        
        while(!_continue){
            usleep(1000)
        }
        
        return result
    }
    
    func requestGET(urlString:String) -> [String: Any]? {

        var jsonResult:[String: Any]? = nil
        var _continue = false
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return nil
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("error calling GET on " + urlString)
                print(error!)
                _continue = true
                return
            }

            guard let responseData = data else {
                print("Error: did not receive data")
                _continue = true
                return
            }
            
            do
            {
                guard let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                jsonResult = jsonObject
                _continue = true
                
            } catch  {
                print("error trying to convert data to JSON")
                _continue = true
                return
            }
        }
        task.resume()
        
        while(!_continue){
            usleep(1000)
        }
        
        return jsonResult
    }
    
    public func requestPOST(urlString:String) -> Bool {
        
        var returnResult:Bool = true
        var _continue = false
        
        guard let urlObject = URL(string: urlString) else {
            print("Error: cannot create URL")
            returnResult = false
            _continue = true
            return returnResult
        }
        
        var myUrlRequest = URLRequest(url: urlObject)
        myUrlRequest.httpMethod = "POST"
        let session = URLSession.shared
        
        let task = session.dataTask(with: myUrlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("error calling POST")
                print(error!)
                returnResult = false
                _continue = true
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                returnResult = false
                _continue = true
                return
            }
            
            do {
                guard let receivedResponse = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            returnResult = false
                                                                            _continue = true
                                                                            return
                }
                print("The response is: " + receivedResponse.description)
                
                guard let result = receivedResponse["result"] as? String else {
                    print("Could not get response")
                    returnResult = false
                    _continue = true
                    return
                }
                print("Reserve result is: \(result)")
                
                if(result == "success") {
                    _continue = true
                    returnResult = true
                }
                
            } catch  {
                print("error parsing response from POST")
                returnResult = false
                _continue = true
            }
        }
        task.resume()
        
        while(!_continue){
            usleep(1000)
        }
        
        return returnResult
    }
}
